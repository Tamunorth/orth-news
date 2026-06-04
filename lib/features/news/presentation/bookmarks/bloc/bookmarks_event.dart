part of 'bookmarks_bloc.dart';

sealed class BookmarksEvent extends Equatable {
  const BookmarksEvent();

  @override
  List<Object?> get props => [];
}

/// Adds the article if it isn't saved, removes it if it is.
final class BookmarkToggled extends BookmarksEvent {
  const BookmarkToggled(this.article);

  final Article article;

  @override
  List<Object?> get props => [article];
}

/// Updates the in-memory search query used to filter saved articles.
final class BookmarksQueryChanged extends BookmarksEvent {
  const BookmarksQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
