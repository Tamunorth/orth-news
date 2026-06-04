import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orth_news/core/enums.dart';
import 'package:orth_news/core/error/failure.dart';
import 'package:orth_news/features/headlines/presentation/bloc/headlines_bloc.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/domain/entities/news_category.dart';
import 'package:orth_news/features/news/domain/usecases/get_top_headlines.dart';

class _MockGetTopHeadlines extends Mock implements GetTopHeadlines {}

void main() {
  late _MockGetTopHeadlines getTopHeadlines;

  setUpAll(() => registerFallbackValue(NewsCategory.general));
  setUp(() => getTopHeadlines = _MockGetTopHeadlines());

  List<Article> page(int n) => List.generate(
    n,
    (i) => Article(title: 'T$i', url: 'u$i', publishedAt: DateTime(2026)),
  );

  void stub(Either<Failure, List<Article>> result) {
    when(
      () => getTopHeadlines(
        category: any(named: 'category'),
        page: any(named: 'page'),
      ),
    ).thenAnswer((_) async => result);
  }

  HeadlinesBloc build() => HeadlinesBloc(getTopHeadlines: getTopHeadlines);

  blocTest<HeadlinesBloc, HeadlinesState>(
    'emits [loading, success] when started',
    setUp: () => stub(Right(page(5))),
    build: build,
    act: (bloc) => bloc.add(const HeadlinesStarted()),
    expect: () => [
      isA<HeadlinesState>().having(
        (s) => s.status,
        'status',
        FetchStatus.loading,
      ),
      isA<HeadlinesState>()
          .having((s) => s.status, 'status', FetchStatus.success)
          .having((s) => s.articles.length, 'count', 5),
    ],
  );

  blocTest<HeadlinesBloc, HeadlinesState>(
    'emits [loading, failure] on error',
    setUp: () => stub(const Left(ServerFailure())),
    build: build,
    act: (bloc) => bloc.add(const HeadlinesStarted()),
    expect: () => [
      isA<HeadlinesState>().having(
        (s) => s.status,
        'status',
        FetchStatus.loading,
      ),
      isA<HeadlinesState>().having(
        (s) => s.status,
        'status',
        FetchStatus.failure,
      ),
    ],
  );

  blocTest<HeadlinesBloc, HeadlinesState>(
    'toggling layout switches list to grid',
    build: build,
    act: (bloc) => bloc.add(const HeadlinesLayoutToggled()),
    expect: () => [
      isA<HeadlinesState>().having((s) => s.layout, 'layout', FeedLayout.grid),
    ],
  );
}
