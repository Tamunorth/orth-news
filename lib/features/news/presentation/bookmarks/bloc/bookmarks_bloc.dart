import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:orth_news/core/typedefs.dart';
import 'package:orth_news/features/news/data/models/article_model.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';

part 'bookmarks_event.dart';
part 'bookmarks_state.dart';

/// Persists saved articles across restarts via [HydratedBloc]. Serialization
/// rides on [ArticleModel]'s NewsAPI-shaped JSON.
class BookmarksBloc extends HydratedBloc<BookmarksEvent, BookmarksState> {
  BookmarksBloc() : super(const BookmarksState()) {
    on<BookmarkToggled>(_onToggled);
    on<BookmarksQueryChanged>(_onQueryChanged);
  }

  void _onToggled(BookmarkToggled event, Emitter<BookmarksState> emit) {
    final article = event.article;
    final updated = state.isBookmarked(article.url)
        ? state.articles.where((a) => a.url != article.url).toList()
        : [article, ...state.articles];
    emit(state.copyWith(articles: updated));
  }

  void _onQueryChanged(
    BookmarksQueryChanged event,
    Emitter<BookmarksState> emit,
  ) {
    emit(state.copyWith(query: event.query));
  }

  @override
  BookmarksState? fromJson(Map<String, dynamic> json) {
    final list = (json['articles'] as List?) ?? const [];
    return BookmarksState(
      articles: list.cast<DataMap>().map(ArticleModel.fromJson).toList(),
    );
  }

  @override
  Map<String, dynamic>? toJson(BookmarksState state) => {
    'articles': state.articles
        .map((a) => ArticleModel.fromEntity(a).toJson())
        .toList(),
  };
}
