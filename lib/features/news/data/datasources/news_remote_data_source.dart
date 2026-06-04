import 'package:dio/dio.dart';
import 'package:orth_news/core/config/app_config.dart';
import 'package:orth_news/core/error/exceptions.dart';
import 'package:orth_news/core/network/news_endpoints.dart';
import 'package:orth_news/core/typedefs.dart';
import 'package:orth_news/features/news/data/models/article_model.dart';

abstract interface class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines({
    required String category,
    required int page,
    required String country,
  });

  Future<List<ArticleModel>> searchArticles({
    required String query,
    required int page,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  const NewsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ArticleModel>> getTopHeadlines({
    required String category,
    required int page,
    required String country,
  }) => _fetch(NewsEndpoints.topHeadlines, {
    'country': country,
    'category': category,
    'pageSize': AppConfig.pageSize,
    'page': page,
  });

  @override
  Future<List<ArticleModel>> searchArticles({
    required String query,
    required int page,
  }) => _fetch(NewsEndpoints.everything, {
    'q': query,
    'language': 'en',
    'sortBy': 'publishedAt',
    'pageSize': AppConfig.pageSize,
    'page': page,
  });

  Future<List<ArticleModel>> _fetch(String path, DataMap query) async {
    final response = await _dio.get<DataMap>(path, queryParameters: query);
    final data = response.data ?? const <String, dynamic>{};

    // NewsAPI returns a JSON body with status:"error" on 4xx (we accept <500).
    if (data['status'] == 'error') {
      throw ApiException(
        message: data['message'] as String? ?? 'Request failed.',
        statusCode: response.statusCode,
        code: data['code'] as String?,
      );
    }

    final articles = (data['articles'] as List?) ?? const [];
    return articles
        .cast<DataMap>()
        .map(ArticleModel.fromJson)
        .where((article) => !article.isRemoved)
        .toList();
  }
}
