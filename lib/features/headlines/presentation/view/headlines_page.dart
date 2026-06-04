import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orth_news/app/router/app_routes.dart';
import 'package:orth_news/core/enums.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/core/widgets/app_empty_view.dart';
import 'package:orth_news/core/widgets/app_error_view.dart';
import 'package:orth_news/core/widgets/app_loading_view.dart';
import 'package:orth_news/core/widgets/skeletons.dart';
import 'package:orth_news/features/article_detail/article_route_args.dart';
import 'package:orth_news/features/headlines/presentation/bloc/headlines_bloc.dart';
import 'package:orth_news/features/headlines/presentation/widgets/category_chips.dart';
import 'package:orth_news/features/headlines/presentation/widgets/home_header.dart';
import 'package:orth_news/features/headlines/presentation/widgets/layout_toggle.dart';
import 'package:orth_news/features/headlines/presentation/widgets/section_header.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/domain/entities/news_category.dart';
import 'package:orth_news/features/news/presentation/widgets/article_grid_card.dart';
import 'package:orth_news/features/news/presentation/widgets/article_list_tile.dart';
import 'package:orth_news/features/news/presentation/widgets/bookmark_button.dart';
import 'package:orth_news/features/news/presentation/widgets/featured_article_card.dart';
import 'package:orth_news/features/settings/presentation/bloc/settings_bloc.dart';

class HeadlinesPage extends StatefulWidget {
  const HeadlinesPage({super.key});

  @override
  State<HeadlinesPage> createState() => _HeadlinesPageState();
}

class _HeadlinesPageState extends State<HeadlinesPage> {
  bool _onScrollNotification(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.vertical &&
        metrics.pixels >= metrics.maxScrollExtent - 400) {
      context.read<HeadlinesBloc>().add(const HeadlinesNextPageRequested());
    }
    return false;
  }

  void _open(Article article) => context.push(
    AppRoutes.article,
    extra: ArticleRouteArgs(article: article, heroTag: 'home-${article.url}'),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const HomeHeader(),
          BlocSelector<HeadlinesBloc, HeadlinesState, NewsCategory>(
            selector: (state) => state.category,
            builder: (context, category) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: CategoryChips(
                selected: category,
                onSelected: (value) => context.read<HeadlinesBloc>().add(
                  HeadlinesCategoryChanged(value),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<HeadlinesBloc, HeadlinesState>(
              builder: (context, state) {
                final layout = context
                    .watch<SettingsBloc>()
                    .state
                    .defaultLayout;
                return RefreshIndicator(
                  color: context.colors.accent,
                  onRefresh: () {
                    final bloc = context.read<HeadlinesBloc>()
                      ..add(const HeadlinesRefreshed());
                    return bloc.stream.firstWhere((s) => !s.isRefreshing);
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _onScrollNotification,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.02),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      // Keying on category + layout makes both a category switch
                      // and a list/grid toggle crossfade instead of jump.
                      child: KeyedSubtree(
                        key: ValueKey('${state.category.name}-${layout.name}'),
                        child: _body(context, state, layout),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, HeadlinesState state, FeedLayout layout) {
    if (state.articles.isEmpty) {
      return switch (state.status) {
        FetchStatus.failure => _fill(
          AppErrorView(
            message: state.errorMessage ?? '',
            onRetry: () =>
                context.read<HeadlinesBloc>().add(const HeadlinesStarted()),
          ),
        ),
        FetchStatus.success => _fill(
          AppEmptyView(
            icon: Icons.article_outlined,
            title: context.l10n.emptyHeadlinesTitle,
            subtitle: context.l10n.emptyHeadlinesSubtitle,
          ),
        ),
        FetchStatus.initial || FetchStatus.loading => const FeedSkeleton(),
      };
    }
    return _feed(context, state, layout);
  }

  Widget _fill(Widget child) => CustomScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    slivers: [SliverFillRemaining(hasScrollBody: false, child: child)],
  );

  Widget _feed(BuildContext context, HeadlinesState state, FeedLayout layout) {
    final l10n = context.l10n;
    final isList = layout == FeedLayout.list;
    final articles = state.articles;
    final featured = articles.first;
    final rest = articles.skip(1).toList();

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: l10n.trending),
                const SizedBox(height: 12),
                FeaturedArticleCard(
                  article: featured,
                  heroTag: 'home-${featured.url}',
                  onTap: () => _open(featured),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
            child: SectionHeader(
              title: l10n.latest,
              action: LayoutToggle(
                layout: layout,
                onToggle: () => context.read<SettingsBloc>().add(
                  SettingsDefaultLayoutChanged(
                    isList ? FeedLayout.grid : FeedLayout.list,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isList) _listSliver(context, rest) else _gridSliver(context, rest),
        SliverToBoxAdapter(child: _footer(context, state)),
      ],
    );
  }

  Widget _listSliver(BuildContext context, List<Article> articles) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      sliver: SliverList.separated(
        itemCount: articles.length,
        separatorBuilder: (_, _) =>
            Divider(height: 1, color: context.colors.line),
        itemBuilder: (context, index) {
          final article = articles[index];
          return ArticleListTile(
            article: article,
            heroTag: 'home-${article.url}',
            onTap: () => _open(article),
            trailing: BookmarkButton(article: article, size: 18),
          );
        },
      ),
    );
  }

  Widget _gridSliver(BuildContext context, List<Article> articles) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 900 ? 4 : (width >= 600 ? 3 : 2);
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 18,
          crossAxisSpacing: 13,
          mainAxisExtent: 222,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final article = articles[index];
          return ArticleGridCard(
            article: article,
            heroTag: 'home-${article.url}',
            onTap: () => _open(article),
          );
        }, childCount: articles.length),
      ),
    );
  }

  Widget _footer(BuildContext context, HeadlinesState state) {
    final showLoader =
        !state.hasReachedMax && state.status != FetchStatus.failure;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: showLoader ? const AppLoadingView() : const SizedBox(height: 8),
    );
  }
}
