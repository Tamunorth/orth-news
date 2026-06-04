import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orth_news/core/theme/app_theme.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/presentation/widgets/article_list_tile.dart';

void main() {
  final article = Article(
    title: 'Big headline',
    url: 'https://example.com',
    publishedAt: DateTime(2026),
    description: 'A two line description that should be visible.',
    sourceName: 'BBC News',
  );

  Widget host(VoidCallback onTap) => MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: ArticleListTile(article: article, onTap: onTap),
    ),
  );

  testWidgets('renders title, description and source', (tester) async {
    await tester.pumpWidget(host(() {}));

    expect(find.text('Big headline'), findsOneWidget);
    expect(
      find.text('A two line description that should be visible.'),
      findsOneWidget,
    );
    expect(find.text('BBC News'), findsOneWidget);
  });

  testWidgets('invokes onTap when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(host(() => tapped = true));

    await tester.tap(find.text('Big headline'));
    expect(tapped, isTrue);
  });
}
