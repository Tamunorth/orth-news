import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orth_news/app/router/app_routes.dart';
import 'package:orth_news/core/enums.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/core/widgets/app_empty_view.dart';
import 'package:orth_news/core/widgets/app_error_view.dart';
import 'package:orth_news/core/widgets/search_field.dart';
import 'package:orth_news/core/widgets/skeletons.dart';
import 'package:orth_news/features/article_detail/article_route_args.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/presentation/widgets/article_list_tile.dart';
import 'package:orth_news/features/news/presentation/widgets/bookmark_button.dart';
import 'package:orth_news/features/search/presentation/bloc/search_bloc.dart';
import 'package:orth_news/features/search/presentation/search_focus.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final _focusNode = FocusNode();
  Timer? _focusTimer;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    SearchFocus.instance.signal.addListener(_onFocusRequested);
    // First visit from the home bar: the request fired before this listener
    // existed, so honour the pending flag here.
    if (SearchFocus.instance.pending) _onFocusRequested();
  }

  @override
  void dispose() {
    _focusTimer?.cancel();
    SearchFocus.instance.signal.removeListener(_onFocusRequested);
    _controller.dispose();
    _focusNode.dispose();
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  // Focus only after the tab transition settles, otherwise the field is still
  // off-screen and the request is dropped.
  void _onFocusRequested() {
    if (!SearchFocus.instance.pending) return;
    SearchFocus.instance.consume();
    _focusTimer?.cancel();
    _focusTimer = Timer(const Duration(milliseconds: 150), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final position = _scroll.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      context.read<SearchBloc>().add(const SearchNextPageRequested());
    }
  }

  void _open(Article article) => context.push(
    AppRoutes.article,
    extra: ArticleRouteArgs(article: article, heroTag: 'search-${article.url}'),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.navSearch, style: context.text.headlineMedium),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SearchField(
              controller: _controller,
              focusNode: _focusNode,
              hint: l10n.searchHint,
              onChanged: (value) =>
                  context.read<SearchBloc>().add(SearchQueryChanged(value)),
              onClear: () {
                _controller.clear();
                context.read<SearchBloc>().add(const SearchCleared());
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(builder: _results),
          ),
        ],
      ),
    );
  }

  Widget _results(BuildContext context, SearchState state) {
    final l10n = context.l10n;

    switch (state.status) {
      case FetchStatus.initial:
        return AppEmptyView(
          icon: Icons.search_rounded,
          title: l10n.searchPromptTitle,
          subtitle: l10n.searchPromptSubtitle,
        );
      case FetchStatus.loading when state.results.isEmpty:
        return const FeedSkeleton(featured: false, rows: 7);
      case FetchStatus.failure when state.results.isEmpty:
        return AppErrorView(
          message: state.errorMessage ?? '',
          onRetry: () =>
              context.read<SearchBloc>().add(SearchQueryChanged(state.query)),
        );
      case _ when state.isEmpty:
        return AppEmptyView(
          icon: Icons.search_off_rounded,
          title: l10n.emptySearchTitle,
          subtitle: l10n.emptySearchSubtitle(state.query),
        );
      case _:
        return _resultList(context, state);
    }
  }

  Widget _resultList(BuildContext context, SearchState state) {
    final results = state.results;
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      itemCount: results.length + 1,
      itemBuilder: (context, index) {
        if (index >= results.length) {
          if (state.hasReachedMax) return const SizedBox(height: 8);
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2.4)),
          );
        }
        final article = results[index];
        return Column(
          key: ValueKey(article.url),
          children: [
            ArticleListTile(
              article: article,
              heroTag: 'search-${article.url}',
              onTap: () => _open(article),
              trailing: BookmarkButton(article: article, size: 18),
            ),
            if (index < results.length - 1)
              Divider(height: 1, color: context.colors.line),
          ],
        );
      },
    );
  }
}
