import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orth_news/app/router/app_routes.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/core/widgets/app_empty_view.dart';
import 'package:orth_news/core/widgets/search_field.dart';
import 'package:orth_news/features/bookmarks/presentation/bloc/bookmarks_bloc.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/presentation/widgets/article_list_tile.dart';
import 'package:orth_news/features/news/presentation/widgets/bookmark_button.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _open(Article article) =>
      context.push(AppRoutes.article, extra: article);

  List<Article> _filter(List<Article> articles) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return articles;
    return articles
        .where(
          (a) =>
              a.title.toLowerCase().contains(query) ||
              (a.sourceName ?? '').toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.bookmarksTitle,
                style: context.text.headlineMedium,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SearchField(
              controller: _controller,
              hint: l10n.searchSavedHint,
              onChanged: (value) => setState(() => _query = value),
              onClear: () {
                _controller.clear();
                setState(() => _query = '');
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<BookmarksBloc, BookmarksState>(
              builder: (context, state) {
                if (state.isEmpty) {
                  return AppEmptyView(
                    icon: Icons.bookmark_border_rounded,
                    title: l10n.emptyBookmarksTitle,
                    subtitle: l10n.emptyBookmarksSubtitle,
                  );
                }
                final items = _filter(state.articles);
                if (items.isEmpty) {
                  return AppEmptyView(
                    icon: Icons.search_off_rounded,
                    title: l10n.emptySearchTitle,
                    subtitle: l10n.emptySearchSubtitle(_query),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      Divider(height: 1, color: context.colors.line),
                  itemBuilder: (context, index) {
                    final article = items[index];
                    return ArticleListTile(
                      article: article,
                      onTap: () => _open(article),
                      trailing: BookmarkButton(article: article, size: 18),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
