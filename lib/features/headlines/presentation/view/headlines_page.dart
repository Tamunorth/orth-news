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
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      context.read<HeadlinesBloc>().add(const HeadlinesNextPageRequested());
    }
  }

  void _openArticle(Article article) =>
      context.push(AppRoutes.article, extra: article);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const HomeHeader(),
          // Category drives the whole feed, so it sits up top and stays
          // visible even while the list below is loading.
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
                return RefreshIndicator(
                  color: context.colors.accent,
                  onRefresh: () {
                    final bloc = context.read<HeadlinesBloc>()
                      ..add(const HeadlinesRefreshed());
                    return bloc.stream.firstWhere((s) => !s.isRefreshing);
                  },
                  child: _Body(
                    state: state,
                    controller: _controller,
                    onOpen: _openArticle,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.state,
    required this.controller,
    required this.onOpen,
  });

  final HeadlinesState state;
  final ScrollController controller;
  final void Function(Article) onOpen;

  @override
  Widget build(BuildContext context) {
    if (state.status == FetchStatus.loading && state.articles.isEmpty) {
      return const FeedSkeleton();
    }

    final slivers = <Widget>[];
    if (state.status == FetchStatus.failure && state.articles.isEmpty) {
      slivers.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: AppErrorView(
            message: state.errorMessage ?? '',
            onRetry: () =>
                context.read<HeadlinesBloc>().add(const HeadlinesStarted()),
          ),
        ),
      );
    } else if (state.isEmpty) {
      slivers.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: AppEmptyView(
            icon: Icons.article_outlined,
            title: context.l10n.emptyHeadlinesTitle,
            subtitle: context.l10n.emptyHeadlinesSubtitle,
          ),
        ),
      );
    } else {
      slivers.addAll(_content(context));
    }

    return CustomScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: slivers,
    );
  }

  List<Widget> _content(BuildContext context) {
    final l10n = context.l10n;
    final layout = context.watch<SettingsBloc>().state.defaultLayout;
    final isList = layout == FeedLayout.list;
    final articles = state.articles;

    return [
      if (isList)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: l10n.trending),
                const SizedBox(height: 12),
                FeaturedArticleCard(
                  article: articles.first,
                  onTap: () => onOpen(articles.first),
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
      if (isList)
        _listSliver(context, articles.skip(1).toList())
      else
        _gridSliver(context, articles),
      SliverToBoxAdapter(child: _footer(context)),
    ];
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
            onTap: () => onOpen(article),
            trailing: BookmarkButton(article: article, size: 18),
          );
        },
      ),
    );
  }

  Widget _gridSliver(BuildContext context, List<Article> articles) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 13,
          mainAxisExtent: 222,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final article = articles[index];
          return ArticleGridCard(
            article: article,
            onTap: () => onOpen(article),
          );
        }, childCount: articles.length),
      ),
    );
  }

  Widget _footer(BuildContext context) {
    final showLoader =
        !state.hasReachedMax && state.status != FetchStatus.failure;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: showLoader ? const AppLoadingView() : const SizedBox(height: 8),
    );
  }
}
