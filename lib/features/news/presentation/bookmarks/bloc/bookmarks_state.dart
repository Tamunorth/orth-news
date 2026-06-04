part of 'bookmarks_bloc.dart';

class BookmarksState extends Equatable {
  const BookmarksState({this.articles = const [], this.query = ''});

  final List<Article> articles;
  final String query;

  /// True when no articles have been saved at all.
  bool get isEmpty => articles.isEmpty;

  bool isBookmarked(String url) => articles.any((a) => a.url == url);

  /// Saved articles matching [query] (case-insensitive, title or source).
  /// Returns all saved articles when the query is blank.
  List<Article> get filtered {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return articles;
    return articles
        .where(
          (a) =>
              a.title.toLowerCase().contains(q) ||
              (a.sourceName ?? '').toLowerCase().contains(q),
        )
        .toList();
  }

  /// True when articles are saved but none match the active query.
  bool get hasNoMatches => articles.isNotEmpty && filtered.isEmpty;

  BookmarksState copyWith({List<Article>? articles, String? query}) {
    return BookmarksState(
      articles: articles ?? this.articles,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [articles, query];
}
