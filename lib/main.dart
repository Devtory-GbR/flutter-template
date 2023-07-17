import 'package:myapp/app.dart';
import 'package:myapp/config/environment.dart';

void main() async {
  // read the env from env startup parameter
  // dev: flutter run
  // staging: flutter run --dart-define=ENV=STAGING
  // prod: flutter run --dart-define=ENV=PROD
  const env = String.fromEnvironment('ENV', defaultValue: Environment.dev);
  await Application(env: env).bootstrapApp();
}
