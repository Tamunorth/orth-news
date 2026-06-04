import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:orth_news/core/config/app_config.dart';
import 'package:orth_news/core/enums.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/domain/entities/news_category.dart';
import 'package:orth_news/features/news/domain/usecases/get_top_headlines.dart';

part 'headlines_event.dart';
part 'headlines_state.dart';

class HeadlinesBloc extends Bloc<HeadlinesEvent, HeadlinesState> {
  HeadlinesBloc({
    required GetTopHeadlines getTopHeadlines,
    FeedLayout initialLayout = FeedLayout.list,
  }) : _getTopHeadlines = getTopHeadlines,
       super(HeadlinesState(layout: initialLayout)) {
    on<HeadlinesStarted>(_onStarted);
    on<HeadlinesRefreshed>(_onRefreshed);
    on<HeadlinesCategoryChanged>(
      _onCategoryChanged,
      transformer: restartable(),
    );
    on<HeadlinesNextPageRequested>(_onNextPage, transformer: droppable());
    on<HeadlinesLayoutToggled>(_onLayoutToggled);
  }

  final GetTopHeadlines _getTopHeadlines;

  Future<void> _onStarted(
    HeadlinesStarted event,
    Emitter<HeadlinesState> emit,
  ) => _loadFirstPage(emit, state.category);

  Future<void> _onRefreshed(
    HeadlinesRefreshed event,
    Emitter<HeadlinesState> emit,
  ) => _loadFirstPage(emit, state.category);

  Future<void> _onCategoryChanged(
    HeadlinesCategoryChanged event,
    Emitter<HeadlinesState> emit,
  ) => _loadFirstPage(emit, event.category);

  void _onLayoutToggled(
    HeadlinesLayoutToggled event,
    Emitter<HeadlinesState> emit,
  ) {
    emit(
      state.copyWith(
        layout: state.layout == FeedLayout.list
            ? FeedLayout.grid
            : FeedLayout.list,
      ),
    );
  }

  Future<void> _loadFirstPage(
    Emitter<HeadlinesState> emit,
    NewsCategory category,
  ) async {
    emit(
      state.copyWith(
        status: FetchStatus.loading,
        category: category,
        articles: const [],
        page: 1,
        hasReachedMax: false,
      ),
    );

    final result = await _getTopHeadlines(category: category, page: 1);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FetchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (articles) => emit(
        state.copyWith(
          status: FetchStatus.success,
          articles: articles,
          page: 1,
          hasReachedMax: _reachedMax(articles.length, articles.length),
        ),
      ),
    );
  }

  Future<void> _onNextPage(
    HeadlinesNextPageRequested event,
    Emitter<HeadlinesState> emit,
  ) async {
    if (state.hasReachedMax || state.status != FetchStatus.success) return;

    final nextPage = state.page + 1;
    final result = await _getTopHeadlines(
      category: state.category,
      page: nextPage,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FetchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (fetched) {
        final merged = _mergeUnique(state.articles, fetched);
        emit(
          state.copyWith(
            articles: merged,
            page: nextPage,
            hasReachedMax: _reachedMax(fetched.length, merged.length),
          ),
        );
      },
    );
  }

  /// The free tier caps any query at 100 results, so we stop there or when a
  /// short page comes back.
  bool _reachedMax(int pageCount, int total) =>
      pageCount < AppConfig.pageSize || total >= AppConfig.maxResults;

  List<Article> _mergeUnique(List<Article> current, List<Article> incoming) {
    final seen = current.map((a) => a.url).toSet();
    return [...current, ...incoming.where((a) => seen.add(a.url))];
  }
}
