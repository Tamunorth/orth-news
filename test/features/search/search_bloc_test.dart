import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orth_news/core/enums.dart';
import 'package:orth_news/core/error/failure.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/domain/usecases/search_articles.dart';
import 'package:orth_news/features/search/presentation/bloc/search_bloc.dart';

class _MockSearchArticles extends Mock implements SearchArticles {}

void main() {
  late _MockSearchArticles searchArticles;

  setUp(() => searchArticles = _MockSearchArticles());

  final results = [
    Article(title: 'Climate', url: 'u', publishedAt: DateTime(2026)),
  ];

  void stub(Either<Failure, List<Article>> result) {
    when(
      () => searchArticles(
        query: any(named: 'query'),
        page: any(named: 'page'),
      ),
    ).thenAnswer((_) async => result);
  }

  blocTest<SearchBloc, SearchState>(
    'debounces then emits [loading, success] for a query',
    setUp: () => stub(Right(results)),
    build: () => SearchBloc(searchArticles: searchArticles),
    act: (bloc) => bloc.add(const SearchQueryChanged('climate')),
    wait: const Duration(milliseconds: 450),
    expect: () => [
      isA<SearchState>().having((s) => s.status, 'status', FetchStatus.loading),
      isA<SearchState>()
          .having((s) => s.status, 'status', FetchStatus.success)
          .having((s) => s.results.length, 'count', 1),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'clearing resets to the initial state',
    build: () => SearchBloc(searchArticles: searchArticles),
    seed: () =>
        SearchState(status: FetchStatus.success, query: 'x', results: results),
    act: (bloc) => bloc.add(const SearchCleared()),
    expect: () => [
      isA<SearchState>()
          .having((s) => s.status, 'status', FetchStatus.initial)
          .having((s) => s.results, 'results', isEmpty),
    ],
  );
}
