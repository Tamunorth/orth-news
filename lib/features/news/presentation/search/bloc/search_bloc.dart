import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:orth_news/core/config/app_config.dart';
import 'package:orth_news/core/enums.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/domain/usecases/search_articles.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';
part 'search_state.dart';

/// Debounces incoming queries and keeps only the latest in flight: stale
/// responses from abandoned keystrokes are discarded.
EventTransformer<E> _debounceRestartable<E>(Duration duration) {
  return (events, mapper) =>
      restartable<E>().call(events.debounce(duration), mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required SearchArticles searchArticles})
    : _searchArticles = searchArticles,
      super(const SearchState()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: _debounceRestartable(AppConfig.searchDebounce),
    );
    on<SearchNextPageRequested>(_onNextPage, transformer: droppable());
    on<SearchCleared>(_onCleared);
  }

  final SearchArticles _searchArticles;

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const SearchState());
      return;
    }

    emit(
      state.copyWith(
        status: FetchStatus.loading,
        query: query,
        results: const [],
        page: 1,
        hasReachedMax: false,
      ),
    );

    final result = await _searchArticles(query: query, page: 1);
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
          results: articles,
          page: 1,
          hasReachedMax: _reachedMax(articles.length, articles.length),
        ),
      ),
    );
  }

  Future<void> _onNextPage(
    SearchNextPageRequested event,
    Emitter<SearchState> emit,
  ) async {
    if (state.hasReachedMax ||
        state.status != FetchStatus.success ||
        state.query.isEmpty) {
      return;
    }

    final nextPage = state.page + 1;
    final result = await _searchArticles(query: state.query, page: nextPage);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FetchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (fetched) {
        final merged = _mergeUnique(state.results, fetched);
        emit(
          state.copyWith(
            results: merged,
            page: nextPage,
            hasReachedMax: _reachedMax(fetched.length, merged.length),
          ),
        );
      },
    );
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) =>
      emit(const SearchState());

  bool _reachedMax(int pageCount, int total) =>
      pageCount < AppConfig.pageSize || total >= AppConfig.maxResults;

  List<Article> _mergeUnique(List<Article> current, List<Article> incoming) {
    final seen = current.map((a) => a.url).toSet();
    return [...current, ...incoming.where((a) => seen.add(a.url))];
  }
}
