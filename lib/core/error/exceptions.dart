/// Raised by the data layer when NewsAPI returns an error response. Carries the
/// HTTP status and the API's own `{code, message}` so the repository can map it
/// to a typed `Failure`.
class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.code,
  });

  final String message;
  final int? statusCode;
  final String? code;

  @override
  String toString() => 'ApiException($statusCode, $code): $message';
}
