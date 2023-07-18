import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart' as intl;
import 'package:logging/logging.dart';
import 'package:myapp/authentication/authentication.dart';
import 'package:myapp/config/environment.dart';
import 'package:myapp/init/init.dart';
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

    //Clean olf log olde then 7 days --> so we don't messup the device
    await LoggerRepository.instance.cleanOldLogs();

    // Log global errors caught by flutter
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      Logger('FlutterError').shout(details, details, details.stack);
    };

    // Log gloable erros not caught by flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      Logger('PlatformDispatcher').shout(error, error, stack);
      if (kDebugMode) {
        return false;
      } else {
        return true;
      }
    };

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

    // Set up global logger for the bloc's und cubit's
    Bloc.observer = AppBlocObserver();

    // finaly start the app
    runApp(const MyApp());

    // now we remove the splash screen after all is done :)
    FlutterNativeSplash.remove();
  }
}

class AppBlocObserver extends BlocObserver {
  final log = Logger('AppBlocObserver');

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
  void onHttpError(HttpException error, StackTrace stackTrace) {
    log.severe('onHttpError -- ${error.message}', error, stackTrace);
    super.onHttpError(error, stackTrace);

    // At these point we just assume, then when the Http Response is 401
    // the auth token is no longe valid --> the we will globally log the user out
    // so that we don't have to check it for each request
    if (error.statusCode == 401) {
      _authenticationRepository.logOut();
    }
  }

  @override
  void onClientError(NetworkException error, StackTrace stackTrace) {
    log.severe('onClientError -- ${error.message}', error, stackTrace);
    super.onClientError(error, stackTrace);
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

  @override
  void initState() {
    super.initState();
    _settingsRepository = SettingsRepository();
    _authenticationRepository = AuthenticationRepository();
    _userRepository = UserRepository();
    _loggerRepository = LoggerRepository.instance;

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
        child: const MyAppView(),
      ),
    );
  }
}

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  static final routerDelegate = BeamerDelegate(
    initialPath: '/',
    locationBuilder: RoutesLocationBuilder(
      routes: appRoutes,
    ),
    guards: appGuards,
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<InitializedCubit, bool>(
          listener: (context, state) {
            routerDelegate.update();
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            routerDelegate.update();
          },
        ),
      ],
      child: BlocBuilder<ThemeCubit, AppTheme>(
        builder: (_, appTheme) {
          return BlocBuilder<LocaleCubit, AppLocale>(
            builder: (_, appLocale) {
              return MaterialApp.router(
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context)?.title ?? '',
                theme: appTheme.theme,
                routerDelegate: routerDelegate,
                routeInformationParser: BeamerParser(),
                backButtonDispatcher: BeamerBackButtonDispatcher(
                    delegate: routerDelegate, alwaysBeamBack: false),
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