import 'package:orth_news/core/typedefs.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/domain/repositories/news_repository.dart';

/// Full-text search over NewsAPI's `everything` endpoint.
class SearchArticles {
  const SearchArticles(this._repository);

  final NewsRepository _repository;

  ResultFuture<List<Article>> call({
    required String query,
    required int page,
  }) => _repository.searchArticles(query: query, page: page);
}
