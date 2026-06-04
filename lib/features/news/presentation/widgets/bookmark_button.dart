import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/presentation/bookmarks/bloc/bookmarks_bloc.dart';

/// Toggles the article in [BookmarksBloc] and reflects saved state. Rebuilds on
/// every bookmarks change (the icon is cheap) so a recycled row never shows a
/// stale icon.
class BookmarkButton extends StatelessWidget {
  const BookmarkButton({required this.article, this.size = 20, super.key});

  final Article article;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocBuilder<BookmarksBloc, BookmarksState>(
      builder: (context, state) {
        final saved = state.isBookmarked(article.url);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () =>
              context.read<BookmarksBloc>().add(BookmarkToggled(article)),
          child: Icon(
            saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            size: size,
            color: saved ? colors.accent : colors.muted,
          ),
        );
      },
    );
  }
}
