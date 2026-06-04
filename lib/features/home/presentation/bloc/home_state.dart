part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = FetchStatus.initial,
    this.category = NewsCategory.general,
    this.articles = const [],
    this.hasReachedMax = false,
    this.page = 1,
    this.isRefreshing = false,
    this.errorMessage,
  });

  final FetchStatus status;
  final NewsCategory category;
  final List<Article> articles;
  final bool hasReachedMax;
  final int page;
  final bool isRefreshing;
  final String? errorMessage;

  bool get isEmpty => status == FetchStatus.success && articles.isEmpty;

  HomeState copyWith({
    FetchStatus? status,
    NewsCategory? category,
    List<Article>? articles,
    bool? hasReachedMax,
    int? page,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      category: category ?? this.category,
      articles: articles ?? this.articles,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    category,
    articles,
    hasReachedMax,
    page,
    isRefreshing,
    errorMessage,
  ];
}
