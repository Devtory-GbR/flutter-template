import 'package:meta/meta.dart';
import 'package:repositories/repositories.dart';

abstract class HttpObserver {
  // Called whenever a MyAppHttpClient is sending a request
  @mustCallSuper
  void onSend(BaseRequest request) {}

  // Called whenever a MyAppHttpClient raised an ClientError exception
  // usally it has here to do, if there is a network problem or the server can't reached
  // is good to for loggin purpuso or handle client exceptions globally
  @mustCallSuper
  void onClientError(NetworkException error, StackTrace stackTrace) {}

  // Called whenever a MyAppHttpClient raised an HttpError (statuscode >= 400)
  // fo instance a good point to check globally an error for invalid auth token error 401
  @mustCallSuper
  void onHttpError(HttpException error, StackTrace stackTrace) {}
}
