import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

import 'config.dart';

class Environment {
  static const String dev = 'DEV';
  static const String staging = 'STAGING';
  static const String prod = 'PROD';

  static final Environment _instance = Environment._internal();
  factory Environment() => _instance;

  Environment._internal();

  final _log = Logger('Environment');

  BaseConfig? _config;

  BaseConfig get config => _config!;
  Map<String, dynamic> get env => _config!.env;

  Future<void> initConfig(String environment) async {
    Map<String, dynamic> env = {};
    try {
      env = jsonDecode(await rootBundle.loadString('./env.json'));
    } catch (e, stackTrace) {
      _log.severe(e.toString(), e, stackTrace);
    }
    _config = _getConfig(environment, env);
  }

  BaseConfig _getConfig(String environment, Map<String, dynamic> env) {
    switch (environment) {
      case Environment.prod:
        return ConfigProduction(env: env);
      case Environment.staging:
        return ConfigStaging(env: env);
      default:
        return ConfigDevelopment(env: env);
    }
  }
}
