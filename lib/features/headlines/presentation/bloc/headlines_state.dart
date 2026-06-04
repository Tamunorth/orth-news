part of 'headlines_bloc.dart';

class HeadlinesState extends Equatable {
  const HeadlinesState({
    this.status = FetchStatus.initial,
    this.category = NewsCategory.general,
    this.layout = FeedLayout.list,
    this.articles = const [],
    this.hasReachedMax = false,
    this.page = 1,
    this.errorMessage,
  });

  final FetchStatus status;
  final NewsCategory category;
  final FeedLayout layout;
  final List<Article> articles;
  final bool hasReachedMax;
  final int page;
  final String? errorMessage;

  bool get isEmpty => status == FetchStatus.success && articles.isEmpty;

  HeadlinesState copyWith({
    FetchStatus? status,
    NewsCategory? category,
    FeedLayout? layout,
    List<Article>? articles,
    bool? hasReachedMax,
    int? page,
    String? errorMessage,
  }) {
    return HeadlinesState(
      status: status ?? this.status,
      category: category ?? this.category,
      layout: layout ?? this.layout,
      articles: articles ?? this.articles,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    category,
    layout,
    articles,
    hasReachedMax,
    page,
    errorMessage,
  ];
}
