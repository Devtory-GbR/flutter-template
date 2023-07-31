import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:logging/logging.dart';
import 'package:myapp/authentication/authentication.dart';
import 'package:myapp/config/environment.dart';
import 'package:myapp/error/error.dart';
import 'package:myapp/init/init.dart';
import 'package:myapp/log/cubit/log_list_cubit.dart';
import 'package:myapp/routes.dart';
import 'package:myapp/settings/settings.dart';
import 'package:repositories/repositories.dart';

class Application {
  final String env;

  Application({required this.env});

  Future<void> bootstrapApp() async {
    // At these point we don't wanna close the splash screen to we will do it later
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // Setup the Logger
    Logger.root.level = kDebugMode ? Level.ALL : Level.WARNING;
    Logger.root.onRecord.listen(
      (LogRecord record) {
        if (kDebugMode) {
          print(
              '${record.time}[${record.level.name}] ${record.loggerName}: ${record.message}');
        }
        try {
          LoggerRepository.instance.addLog(
            name: record.loggerName,
            level: record.level.value,
            time: record.time,
            message: record.message,
            stackTrace: record.stackTrace,
          );
        } catch (e, stacktrace) {
          // At these point we don't wann log again
          // then we will run in an infinitie loop
          if (kDebugMode) {
            print(e);
            print(stacktrace);
          }
        }
      },
    );

    // Log global errors caught by flutter
    FlutterError.onError = (FlutterErrorDetails details) {
      Logger('FlutterError').shout(details, details, details.stack);
      FlutterError.presentError(details);
    };

    // Log gloable erros not caught by flutter
    // usally we should not reach these point --> so far it should be catche
    // in the bloc's logic
    PlatformDispatcher.instance.onError = (error, stack) {
      Logger('PlatformDispatcher').shout(error, error, stack);
      if (kDebugMode) {
        return false;
      } else {
        return true;
      }
    };

    //Clean olf log olde then 7 days --> so we don't messup the device
    await LoggerRepository.instance.cleanOldLogs();

    // Set up the Environment
    await Environment().initConfig(env);

    // Add own thrid party licences
    // it should be done for all thrid party you add without the pub.dev
    // e.g. fonts etc...
    // it will be shown than auto. on the settings page
    LicenseRegistry.addLicense(() async* {
      final license =
          await rootBundle.loadString('fonts/clicker-script/OFL.txt');
      yield LicenseEntryWithLineBreaks(['ClickerScript'], license);
    });

    //Set the default locale
    intl.Intl.defaultLocale = 'en_US';

    // finaly start the app
    runApp(const MyApp());

    // now we remove the splash screen after all is done :)
    FlutterNativeSplash.remove();
  }
}

class AppBlocObserver extends BlocObserver {
  final log = Logger('AppBlocObserver');

  final GlobalKey<ScaffoldMessengerState> scaffoldKey;
  final GlobalKey<NavigatorState> navigatorKey;

  AppBlocObserver({required this.scaffoldKey, required this.navigatorKey});

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log.fine('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log.fine('onEvent -- ${bloc.runtimeType}, $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    // If it is the LogList Cubit --> we don't wanna Log any change
    // otherwise we will run in a infinity loop --> for each log the cubit will change
    // to display the logs
    if (bloc is LogListCubit) {
      return;
    }

    log.fine('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log.fine('onTransition -- ${bloc.runtimeType}, $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log.severe('onError -- ${bloc.runtimeType}, $error', error, stackTrace);
    super.onError(bloc, error, stackTrace);

    // if the error is a http error with auth required,
    // we assume at these point that the token is no longer valid an logout
    // and redirect the user to the login page --> so we wanna show a snackbar so that
    // is is shown ofer the screens
    if (error is HttpException && error.statusCode == 401) {
      // you can show a snack bar
      if (scaffoldKey.currentContext != null) {
        scaffoldKey.currentState!
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(scaffoldKey.currentContext!)!
                  .errorInvalidTokenAutoLogout),
            ),
          );
      }
      return;
    }

    // or maybe just a dialog
    if (navigatorKey.currentContext != null) {
      showErrorDialog(
          context: navigatorKey.currentContext!,
          error: error,
          stackTrace: stackTrace);
    }
  }
}

class AppHttpObserver extends HttpObserver {
  final log = Logger('AppHttpObserver');

  final AuthenticationRepository _authenticationRepository;

  AppHttpObserver({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository;

  @override
  void onSend(BaseRequest request) {
    super.onSend(request);
    log.fine('onSend -- ${request.url}');
  }

  @override
  void onHttpErrorResponse(BaseRequest request, int statusCode) {
    // At these point we just assume, then when the Http Response is 401
    // the auth token is no longe valid --> the we will globally log the user out
    // so that we don't have to check it for each request
    if (statusCode == 401) {
      _authenticationRepository.logOut();
    }
    super.onHttpErrorResponse(request, statusCode);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SettingsRepository _settingsRepository;
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;
  late final LoggerRepository _loggerRepository;

  final log = Logger('App');

  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _settingsRepository = SettingsRepository();
    _authenticationRepository = AuthenticationRepository();
    _userRepository = UserRepository();
    _loggerRepository = LoggerRepository.instance;

    // Set up global logger for the bloc's
    // and gloabl error handling to show on dialog
    Bloc.observer =
        AppBlocObserver(scaffoldKey: scaffoldKey, navigatorKey: navigatorKey);

    // Set up Http Client
    MyAppHttpClient.clientURL = Environment().env['CLIENT_URL'] ?? '';
    MyAppHttpClient.observer =
        AppHttpObserver(authenticationRepository: _authenticationRepository);

    log.fine("App - initState");
  }

  @override
  void dispose() {
    log.fine("App - dispose");

    _authenticationRepository.dispose();
    _loggerRepository.clearListeners();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    log.fine("App - build");

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _settingsRepository),
        RepositoryProvider.value(value: _loggerRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: true,
            create: (_) => InitializedCubit()
              ..initApp(authenticationRepository: _authenticationRepository),
          ),
          BlocProvider(
            lazy: true,
            create: (_) => AuthenticationBloc(
                authenticationRepository: _authenticationRepository,
                userRepository: _userRepository),
          ),
          BlocProvider(
              create: (_) => ThemeCubit(themePersistence: _settingsRepository)),
          BlocProvider(
              create: (_) =>
                  LocaleCubit(localePersistence: _settingsRepository)),
        ],
        child: MyAppView(scaffoldKey: scaffoldKey, navigatorKey: navigatorKey),
      ),
    );
  }
}

class MyAppView extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;
  final GlobalKey<NavigatorState> navigatorKey;

  final GoRouter _router;
  MyAppView({super.key, required this.scaffoldKey, required this.navigatorKey})
      : _router = GoRouter(
            initialLocation: '/',
            navigatorKey: navigatorKey,
            routes: appRoutes,
            redirect: appRedirect);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<InitializedCubit, bool>(
          listener: (context, state) {
            _router.refresh();
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            _router.refresh();
          },
        ),
      ],
      child: BlocBuilder<ThemeCubit, AppTheme>(
        builder: (_, appTheme) {
          return BlocBuilder<LocaleCubit, AppLocale>(
            builder: (_, appLocale) {
              return MaterialApp.router(
                scaffoldMessengerKey: scaffoldKey,
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context)?.title ?? '',
                theme: appTheme.theme,
                routerConfig: _router,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                // feel free to just add more language support to your app
                // for that just create a new app_XX.arb file in lib/i10n
                // and to forget to attend the new language code in languageChoice in app_en.arb
                supportedLocales: const [
                  //just set en to first position, so it is our fallback language
                  Locale('en'),
                  ...AppLocalizations.supportedLocales
                ],
                locale: appLocale.locale,
              );
            },
          );
        },
      ),
    );
  }
}
