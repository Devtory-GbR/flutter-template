class NetworkException implements Exception {
  final String message;
  final String? uri;

  NetworkException(this.message, [this.uri]);

  @override
  String toString() => message;
}

class HttpException implements Exception {
  final String message;
  final String? uri;
  final int? statusCode;

  HttpException(this.message, [this.uri, this.statusCode]);

  @override
  String toString() => message;
}
