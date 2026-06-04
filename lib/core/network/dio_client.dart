import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:orth_news/core/network/api_interceptor.dart';
import 'package:orth_news/core/network/news_endpoints.dart';

/// Builds the single configured [Dio] instance used by the data layer.
Dio buildDio({required String apiKey}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: NewsEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {'Accept': 'application/json'},
      // NewsAPI returns a JSON body even on 4xx/5xx; let us read it.
      validateStatus: (status) => status != null && status < 500,
    ),
  )..interceptors.add(ApiKeyInterceptor(apiKey));

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestHeader: false),
    );
  }
  return dio;
}
