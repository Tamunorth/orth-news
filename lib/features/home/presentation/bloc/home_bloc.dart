import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:orth_news/core/config/app_config.dart';
import 'package:orth_news/core/enums.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/domain/entities/news_category.dart';
import 'package:orth_news/features/news/domain/usecases/get_top_headlines.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required GetTopHeadlines getTopHeadlines})
    : _getTopHeadlines = getTopHeadlines,
      super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeRefreshed>(_onRefreshed, transformer: restartable());
    on<HomeCategoryChanged>(
      _onCategoryChanged,
      transformer: restartable(),
    );
    on<HomeNextPageRequested>(_onNextPage, transformer: droppable());
  }

  final GetTopHeadlines _getTopHeadlines;

  /// Per-category in-memory cache so switching categories is instant.
  final Map<NewsCategory, _CategoryCache> _cache = {};

  Future<void> _onStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) => _show(emit, state.category);

  Future<void> _onCategoryChanged(
    HomeCategoryChanged event,
    Emitter<HomeState> emit,
  ) => _show(emit, event.category);

  /// Shows cached results immediately when present (then refreshes silently),
  /// otherwise shows a loading state while fetching the first page.
  Future<void> _show(
    Emitter<HomeState> emit,
    NewsCategory category,
  ) async {
    final cached = _cache[category];
    if (cached != null) {
      emit(
        HomeState(
          status: FetchStatus.success,
          category: category,
          articles: cached.articles,
          page: cached.page,
          hasReachedMax: cached.hasReachedMax,
        ),
      );
      await _fetchFirstPage(emit, category, showLoading: false);
    } else {
      await _fetchFirstPage(emit, category, showLoading: true);
    }
  }

  Future<void> _onRefreshed(
    HomeRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));
    await _fetchFirstPage(emit, state.category, showLoading: false);
    if (!emit.isDone && state.isRefreshing) {
      emit(state.copyWith(isRefreshing: false));
    }
  }

  Future<void> _fetchFirstPage(
    Emitter<HomeState> emit,
    NewsCategory category, {
    required bool showLoading,
  }) async {
    if (showLoading) {
      emit(HomeState(status: FetchStatus.loading, category: category));
    }

    final result = await _getTopHeadlines(category: category, page: 1);
    if (emit.isDone) return;

    result.fold(
      (failure) {
        // Keep showing cached data on a silent refresh; only surface the
        // error when there is nothing else on screen.
        if (state.articles.isEmpty) {
          emit(
            state.copyWith(
              status: FetchStatus.failure,
              category: category,
              isRefreshing: false,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (articles) {
        final reached = _isMax(articles.length, articles.length);
        _cache[category] = _CategoryCache(articles, 1, hasReachedMax: reached);
        if (state.category == category) {
          emit(
            HomeState(
              status: FetchStatus.success,
              category: category,
              articles: articles,
              hasReachedMax: reached,
            ),
          );
        }
      },
    );
  }

  Future<void> _onNextPage(
    HomeNextPageRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (state.hasReachedMax || state.status != FetchStatus.success) return;

    final category = state.category;
    final nextPage = state.page + 1;
    final result = await _getTopHeadlines(category: category, page: nextPage);
    if (emit.isDone) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FetchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (fetched) {
        final merged = _mergeUnique(state.articles, fetched);
        final reached = _isMax(fetched.length, merged.length);
        _cache[category] = _CategoryCache(
          merged,
          nextPage,
          hasReachedMax: reached,
        );
        emit(
          state.copyWith(
            articles: merged,
            page: nextPage,
            hasReachedMax: reached,
          ),
        );
      },
    );
  }

  bool _isMax(int pageCount, int total) =>
      pageCount < AppConfig.pageSize || total >= AppConfig.maxResults;

  List<Article> _mergeUnique(List<Article> current, List<Article> incoming) {
    final seen = current.map((a) => a.url).toSet();
    return [...current, ...incoming.where((a) => seen.add(a.url))];
  }
}

class _CategoryCache {
  const _CategoryCache(
    this.articles,
    this.page, {
    required this.hasReachedMax,
  });

  final List<Article> articles;
  final int page;
  final bool hasReachedMax;
}
