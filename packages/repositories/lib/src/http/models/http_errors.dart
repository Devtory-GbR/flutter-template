class HttpException implements Exception {
  final String message;
  final String? uri;
  final int? statusCode;

  HttpException(this.message, [this.uri, this.statusCode]);

  @override
  String toString() => message;
}
