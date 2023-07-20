import 'package:meta/meta.dart';
import 'package:repositories/repositories.dart';

abstract class HttpObserver {
  // Called whenever a MyAppHttpClient is sending a request
  @mustCallSuper
  void onSend(BaseRequest request) {}

  // Called whenever a MyAppHttpClient raised an HttpError (statuscode >= 400)
  // fo instance a good point to check globally an error for invalid auth token error 401
  @mustCallSuper
  void onHttpErrorResponse(BaseRequest request, int statusCode) {}
}
