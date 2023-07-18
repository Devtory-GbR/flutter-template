abstract class BaseConfig {
  BaseConfig({required this.env});

  bool get isDev;
  bool get isStaging;
  bool get isProd;

  final Map<String, dynamic> env;
}

class ConfigDevelopment extends BaseConfig {
  ConfigDevelopment({required super.env});

  @override
  bool get isDev => true;
  @override
  bool get isStaging => false;
  @override
  bool get isProd => false;
}

class ConfigStaging extends BaseConfig {
  ConfigStaging({required super.env});

  @override
  bool get isDev => false;
  @override
  bool get isStaging => true;
  @override
  bool get isProd => false;
}

class ConfigProduction extends BaseConfig {
  ConfigProduction({required super.env});

  @override
  bool get isDev => false;
  @override
  bool get isStaging => false;
  @override
  bool get isProd => true;
}
