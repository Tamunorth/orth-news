part of 'bookmarks_bloc.dart';

class BookmarksState extends Equatable {
  const BookmarksState({this.articles = const []});

  final List<Article> articles;

  bool get isEmpty => articles.isEmpty;

  bool isBookmarked(String url) => articles.any((a) => a.url == url);

  @override
  List<Object?> get props => [articles];
}
