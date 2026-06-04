import 'package:dio/dio.dart';

/// Injects the NewsAPI key on every request as the `X-Api-Key` header so it
/// never leaks into request URLs or logs.
class ApiKeyInterceptor extends Interceptor {
  const ApiKeyInterceptor(this.apiKey);

  final String apiKey;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.headers['X-Api-Key'] = apiKey;
    handler.next(options);
  }
}
