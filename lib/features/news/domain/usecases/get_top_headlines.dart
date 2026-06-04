import 'package:orth_news/core/typedefs.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/domain/entities/news_category.dart';
import 'package:orth_news/features/news/domain/repositories/news_repository.dart';

/// Fetches a page of trending headlines for a category.
class GetTopHeadlines {
  const GetTopHeadlines(this._repository);

  final NewsRepository _repository;

  ResultFuture<List<Article>> call({
    required NewsCategory category,
    required int page,
  }) => _repository.getTopHeadlines(category: category, page: page);
}
