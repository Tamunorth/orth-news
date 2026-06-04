import 'package:orth_news/core/typedefs.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/domain/entities/news_category.dart';

abstract interface class NewsRepository {
  ResultFuture<List<Article>> getTopHeadlines({
    required NewsCategory category,
    required int page,
  });

  ResultFuture<List<Article>> searchArticles({
    required String query,
    required int page,
  });
}
