<h1 align="center">MyApp - Flutter template</h1>

<h3 align="center">Flutter project template for easy start</h3>
<p align="center">Just clone the project and build your app on top of it!!! <br /> With a lot of key concepts and features which almost each app needs.</p>
<p align="center"></p>
<p align="center"><a href="https://strapi.io/demo">Try live demo</a></p>
<br />

![](flutter_bootstrap.gif)

**SDK** | ✔️ Flutter

**Plattform** | ✔️ Android ✔️ IOS ✔️ Linux ✔️ MACOS ✔️ WEB ✔️ WINDOWS

_Table of Content_

- [👨‍💻 What's the project about?](#-whats-the-project-about)
- [🚀 Gettign started](#-gettign-started)
- [⭐ Key Concepts and Features](#-key-concepts-and-features)
- [📝 Authors](#-authors)
- [🙏 Credits](#-credits)
- [🧾 License](#-license)
- [🚫 Disclaimer](#-disclaimer)

## 👨‍💻 What's the project about?

It is a simple app wich showing a lot of key concepts like handling theming, internatinalizing, state management, store date, routing and more one.

Furthermore it is not the 1000. todo app which shows only 1 to 2 key concepts. It is a real app wich you can use for start 1:1, without any code removing and showing all on generic features which almost each good app needs like navigation, changing theme and language, about and licence page.

Mainly it is a collection of the top packages (in my oppinion), best practices and cool concepts from serveral tutorials, wrapped all up into one project that you can just start with designing and coding new views 😄.

All the packages are used based on compatibility for all plattforms, under a license for commercial usage, flutters favorite or from the flutter or dart team themeselves and of course a good documentation how to use it.

## 🚀 Gettign started

Just clone the project:

```
git clone ....
```

Install the packages

```
flutter pub get
```

Start the project

```
flutter run
```

**The following steps you may wanna change/adjust:**

- project name
  - name attr in pubspec.yaml
  - be aware afterthat all imports are wrong, just search an replace _'package:myapp_ with _'package:[PROJECTNAME]_
- app name and bundle identifier
  - you can just search for myapp again and replace it
  - otherwise the flutter documentation point out where to change the display and identifiert ([iOS](https://docs.flutter.dev/deployment/ios), [Android](https://docs.flutter.dev/deployment/android))
- [Theming](#theming)

That's all now just start to build your views.

🏁 Have FUN with Coding! 🏁

## ⭐ Key Concepts and Features

- [Environment](#environment) - dev, staging, prod
- [State management](#state-management) - with Flutter Bloc
- [Persistence for small data](#persistence-for-small-data) - with a key-value storage
- [Persistence for large data](#persistence-for-large-data) - local sqllite with drift
- [API Requests](#api-requests-via-http) - via HTTP
- [Routing](#routing) - with real URLs for a web app
- [Internationalizing](#internationalizing)
- [Theming](#theming)
- [Authentication](#authentication)
- [Logging](#logging)
- [Licences](#licences)
- [App and device Info](#app-and-device-info)
- [ListView Handling](#listview-handling)
- [Lint and style guides](#lint-and-style-guides)

**What is missing?**

- Testing
  - Package from Flutter for testing is already added
  - but so far no test are written
  - consider that automated test's are quite need and flutter has a really nice testing framework even for ui
  - https://docs.flutter.dev/testing

### Environment <!-- omit in toc -->

You can run the app in different environment - dev, staging or prod.
During the startup you can then load specific global params over an .env-File e.g. HTTP Url.

**Used Packages**:

- flutter_dotenv (https://pub.dev/packages/flutter_dotenv)

The specific environment is read during the starup from the startup param in the _main.dart_. And then during the bootstrap of the app the _.env_ File in the root-Folder is loaded.

_main.dart_

```dart
// dev: flutter run
// staging: flutter run --dart-define=ENV=STAGING
// prod: flutter run --dart-define=ENV=PROD
const env = String.fromEnvironment('ENV', defaultValue: Environment.dev);
await Application(env: env).bootstrapApp();
```

_.env_

```
CLIENT_URL=https://api.myapp.com
```

_exmaple_

```dart
// access params from the env file over Singleton Environment()
print(Environment().env['CLIENT_URL']);

// access the config instance
// there you can store hard codes params e.g. is dev/staging/prod
// which you dan't wanna editiable via .env
print(Environment().config.isDev);
```

### State management <!-- omit in toc -->

When building production quality applications, managing state becomes critical.

For Flutter you will find several approcheas and solutions - [here](https://docs.flutter.dev/data-and-backend/state-mgmt/options).

I prefere to use the BLoC pattern (by _Felix Angelov_).

**Used Packages**

- flutter_bloc (https://pub.dev/packages/flutter_bloc)

You will find a excelent documentation and a lot of examples here: https://bloclibrary.dev/.

The pattern is used all over the app, you can see the usage for example by the theme, language and log view.

### Persistence for small data <!-- omit in toc -->

If you have a relatively small collection of key-values to save locally.

**Used Packages**:

- shared_preferences (https://pub.dev/packages/shared_preferences)

An example can be found in the app in the settings. The infos of the choosen language or theme by the customer is stored locally on the disk - so that it can load during the next startup - see [settings_repository.dart](./packages\repositories\lib\src\settings\settings_repository.dart)

### Persistence for large data <!-- omit in toc -->

### API Requests via HTTP <!-- omit in toc -->

### Routing <!-- omit in toc -->

### Internationalizing <!-- omit in toc -->

The hole App is unsing text from a translation file. So you can easily add new strings and translate the app in every language you want.

**Used Packages**:

- flutter_localizations (https://pub.dev/packages/flutter_localization)
- intl (https://pub.dev/packages/intl)

A full documentation how it is setup can be found [here](https://docs.flutter.dev/accessibility-and-localization/internationalization), thx to the flutter dev team.

Just put all you translations in _\lib\l10n_.

If you add new strings or complete new language with a new .arb-File run the app again.

Changing the language itself by the user is implemented in the settings section. The views and the logic can be found in [lib\settings\settings.dart](./lib/settingssettings.dart)

The list of all available languges is defined over the supported languages based on the \*.arb-Files. The option for the system language is defined in the [locale_cubit.dart](./lib/settings/cubit/locale_cubit.dart)

```dart
static final systemLocale = AppLocale(
      key: 'system',
      desc: 'systemLanuage',
      locale: Locale(
        Platform.localeName.substring(0, 2),
      ));

static final Map<String, AppLocale> locales = {
  'system': systemLocale,
  for (var locale in AppLocalizations.supportedLocales)
    locale.languageCode.substring(0, 2): AppLocale(
        key: locale.languageCode.substring(0, 2),
        desc: locale.languageCode.substring(0, 2),
        locale: locale)
};
```

### Theming <!-- omit in toc -->

The themes and colors are defined in [lib\styles\colors.dart](./lib/styles/colors.dart) and [lib\styles\themes.dart](./lib/styles/themes.dart).

Feel free to just adjust it or add complete new themes. That the user can choose your theme, don't forget it to add it in the [theme_cubit.dart](./lib/settings/cubit/theme_cubit.dart):

```dart
static final Map<String, AppTheme> themes = {
  'primary':
      AppTheme(key: 'primary', desc: 'light', theme: AppThemes.primary),
  'primaryDark': AppTheme(
      key: 'primaryDark', desc: 'dark', theme: AppThemes.primaryDarkTheme)
};
```

Changing the theme itself by the user is implemented in the settings section. The views and the logic can be found in [lib\settings\settings.dart](./lib/settingssettings.dart)

### Authentication <!-- omit in toc -->

A dummy authentication process is implemented in the bloc pattern.

It is mainly inspired by the following tutorial:
https://bloclibrary.dev/#/flutterlogintutorial

### Logging <!-- omit in toc -->

Handle the logging at one point in the app, with different log levels.

**Used Packages**:

- logging (https://pub.dev/packages/logging)

So far the logs will store in a local database (logs will be deleted after some time), with the idea that maybe the user can send a crash report or other debugging purpose. Also in the debug mode it will all printed in the console.

In the _app.dart_ you can change the log level and change the behaviour:

```dart
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
```

On the about page is the option to see the complete log.

### Licences <!-- omit in toc -->

Showing the licenses is working out of the box with flutter:
https://api.flutter.dev/flutter/material/showLicensePage.html

Thise is implemented in the about page

```dart
ListTile(
  leading: const Icon(Icons.document_scanner),
  title: Text(AppLocalizations.of(context)!.license),
  onTap: () async {
    showLicensePage(context: context);
  },
),
```

Keep in mind, when using other assets e.g. fonts to add also the license to the registry.

A example can found in the _app.dart_:

```dart
LicenseRegistry.addLicense(() async* {
  final license =
      await rootBundle.loadString('fonts/clicker-script/OFL.txt');
  yield LicenseEntryWithLineBreaks(['ClickerScript'], license);
});
```

### App and device info <!-- omit in toc -->

It could ab always convenient to show somewhere the app verions/name/build and also soem device info - specific when you plan to support multiple systems. So the user themeselve can give these informattions easily when report an issue or you can just collect it automaticly.

**Used Packages**:

- package_info_plus (https://pub.dev/packages/package_info_plus)
- device_info_plus (https://pub.dev/packages/device_info_plus)

On the about screen you can find the packages in action.

### ListView Handling <!-- omit in toc -->

### Lint and style guides <!-- omit in toc -->

Get a nice structure of the code and when working with vscode you can even format the code on save.

**Used Packages**:

- flutter_lints (https://pub.dev/packages/flutter_lints)

For the project the recommended settings for flutter projects are used. But you can edit it in the [analysis_options.yaml](./analysis_options.yaml)

## 📝 Authors

- [Martin Weber](https://github.com/ThunderAnimal)

## 🙏 Credits

## 🧾 License

See the [LICENSE](./LICENSE) file for licensing information.

## 🚫 Disclaimer

YOUR ARE FREE TO USE THE CODE IN YOUR PROJECTS HOWEVER MAKE CLEAR THAT THE CODE IS OFFERED "AS-IS, WITHOUT WARRANTY AND DISCLAIMING LIABILITY FOR DAMAGES RESULTING FROM USING THE CODE.
