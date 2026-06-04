part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState({
    this.status = FetchStatus.initial,
    this.query = '',
    this.results = const [],
    this.hasReachedMax = false,
    this.page = 1,
    this.errorMessage,
  });

  final FetchStatus status;
  final String query;
  final List<Article> results;
  final bool hasReachedMax;
  final int page;
  final String? errorMessage;

  bool get isEmpty => status == FetchStatus.success && results.isEmpty;

  SearchState copyWith({
    FetchStatus? status,
    String? query,
    List<Article>? results,
    bool? hasReachedMax,
    int? page,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    query,
    results,
    hasReachedMax,
    page,
    errorMessage,
  ];
}
