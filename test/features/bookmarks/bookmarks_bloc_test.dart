import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orth_news/features/bookmarks/presentation/bloc/bookmarks_bloc.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';

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

  test('isBookmarked reflects saved articles', () {
    const state = BookmarksState();
    expect(state.isBookmarked('u1'), isFalse);
    expect(BookmarksState(articles: [article]).isBookmarked('u1'), isTrue);
  });
}
