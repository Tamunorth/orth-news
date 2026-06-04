import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orth_news/core/enums.dart';
import 'package:orth_news/core/theme/app_theme.dart';
import 'package:orth_news/features/news/presentation/home/widgets/layout_toggle.dart';

void main() {
  testWidgets('tapping the inactive grid segment toggles', (tester) async {
    var toggled = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Center(
            child: LayoutToggle(
              layout: FeedLayout.list,
              onToggle: () => toggled = true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    expect(toggled, isTrue);
  });

  testWidgets('tapping the active segment does nothing', (tester) async {
    var toggled = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Center(
            child: LayoutToggle(
              layout: FeedLayout.list,
              onToggle: () => toggled = true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.view_agenda_outlined));
    expect(toggled, isFalse);
  });
}
