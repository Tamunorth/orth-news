import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/presentation/bookmarks/bloc/bookmarks_bloc.dart';

class _MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = _MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  final article = Article(title: 'T', url: 'u1', publishedAt: DateTime(2026));

  final flutter = Article(
    title: 'Flutter ships 4.0',
    url: 'u1',
    publishedAt: DateTime(2026),
    sourceName: 'TechCrunch',
  );
  final dart = Article(
    title: 'Records land in stable',
    url: 'u2',
    publishedAt: DateTime(2026),
    sourceName: 'The Verge',
  );

  blocTest<BookmarksBloc, BookmarksState>(
    'toggles a bookmark on then off',
    build: BookmarksBloc.new,
    act: (bloc) => bloc
      ..add(BookmarkToggled(article))
      ..add(BookmarkToggled(article)),
    expect: () => [
      isA<BookmarksState>().having((s) => s.articles.length, 'len', 1),
      isA<BookmarksState>().having((s) => s.articles.length, 'len', 0),
    ],
  );

  blocTest<BookmarksBloc, BookmarksState>(
    'BookmarksQueryChanged sets the query and narrows filtered',
    build: BookmarksBloc.new,
    seed: () => BookmarksState(articles: [flutter, dart]),
    act: (bloc) => bloc.add(const BookmarksQueryChanged('flutter')),
    expect: () => [
      isA<BookmarksState>().having((s) => s.query, 'query', 'flutter').having(
        (s) => s.filtered,
        'filtered',
        [flutter],
      ),
    ],
  );

  blocTest<BookmarksBloc, BookmarksState>(
    'BookmarkToggled after a query keeps the query',
    build: BookmarksBloc.new,
    seed: () => BookmarksState(articles: [flutter], query: 'flutter'),
    act: (bloc) => bloc.add(BookmarkToggled(dart)),
    expect: () => [
      isA<BookmarksState>()
          .having((s) => s.query, 'query', 'flutter')
          .having((s) => s.articles.length, 'len', 2),
    ],
  );

  test('isBookmarked reflects saved articles', () {
    const state = BookmarksState();
    expect(state.isBookmarked('u1'), isFalse);
    expect(BookmarksState(articles: [article]).isBookmarked('u1'), isTrue);
  });

  test('filtered: blank query returns all; source match; no-match', () {
    final state = BookmarksState(articles: [flutter, dart]);

    expect(state.filtered, [flutter, dart]);
    expect(state.hasNoMatches, isFalse);

    final bySource = state.copyWith(query: 'verge');
    expect(bySource.filtered, [dart]);

    final noMatch = state.copyWith(query: 'zzz');
    expect(noMatch.filtered, isEmpty);
    expect(noMatch.hasNoMatches, isTrue);
  });
}
