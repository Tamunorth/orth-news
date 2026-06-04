import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orth_news/core/theme/app_theme.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/presentation/bookmarks/bloc/bookmarks_bloc.dart';
import 'package:orth_news/features/news/presentation/widgets/article_grid_card.dart';

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

  // Long enough that both the title and the description hit maxLines: 2 and
  // ellipsize — the worst case the grid-cell extent must accommodate.
  const title = 'Global markets tumble as central banks signal aggressive '
      'coordinated interest rate hikes';
  const description = 'Investors reacted sharply as policymakers across '
      'several major economies hinted at further tightening this year.';
  const source = 'BBC News';

  final article = Article(
    title: title,
    url: 'https://example.com',
    publishedAt: DateTime(2026),
    description: description,
    sourceName: source,
  );

  // Replicates a narrow 2-column grid cell (small phone) so a fully populated
  // card forces both texts to 2 lines and a RenderFlex overflow would throw.
  Widget host() => MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: BlocProvider(
        create: (_) => BookmarksBloc(),
        child: Center(
          child: SizedBox(
            width: 140,
            height: kArticleGridCardExtent,
            child: ArticleGridCard(article: article, onTap: () {}),
          ),
        ),
      ),
    ),
  );

  testWidgets('renders title, description and source without overflow', (
    tester,
  ) async {
    await tester.pumpWidget(host());

    expect(find.text(title), findsOneWidget);
    expect(find.text(description), findsOneWidget);
    expect(find.text(source), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
