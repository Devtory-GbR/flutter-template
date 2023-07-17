import 'package:http/http.dart';
import 'package:repositories/repositories.dart';

class _DefaultHttpObserver extends HttpObserver {}

class MyAppHttpClient extends BaseClient {
  static String clientURL = '';
  static String authToken = '';

  static HttpObserver observer = _DefaultHttpObserver();

  final Client _inner;
  final bool needsAuthorization;

  MyAppHttpClient(this._inner, {this.needsAuthorization = true});

  Uri buildUri(String unencodedPath, [Map<String, dynamic>? queryParameters]) {
    return Uri.parse(clientURL).replace(
      path: unencodedPath,
      queryParameters: queryParameters,
    );
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    if (needsAuthorization) {
      request.headers['Authorization'] = MyAppHttpClient.authToken;
    }
    observer.onSend(request);
    try {
      final streamResponse = await _inner.send(request);
      if (streamResponse.statusCode < 400) {
        return streamResponse;
      }

      var message =
          'Request to ${request.url} failed with status ${streamResponse.statusCode}';
      if (streamResponse.reasonPhrase != null) {
        message = '$message: ${streamResponse.reasonPhrase}';
      }
      final httpException = HttpException(
          message, request.url.toString(), streamResponse.statusCode);
      observer.onHttpError(httpException, StackTrace.current);
      throw httpException;
    } on ClientException catch (e, stackTrace) {
      final networkException = NetworkException(e.message, e.uri?.toString());
      observer.onClientError(networkException, stackTrace);
      throw networkException;
    } catch (e) {
      rethrow;
    }
  }
}
