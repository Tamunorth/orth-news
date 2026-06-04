import 'package:orth_news/features/news/domain/entities/article.dart';

/// Passed as the GoRouter `extra` for the detail route. [heroTag] carries the
/// originating screen's Hero tag so the image flies from the correct card.
class ArticleRouteArgs {
  const ArticleRouteArgs({required this.article, this.heroTag});

  final Article article;
  final Object? heroTag;
}
