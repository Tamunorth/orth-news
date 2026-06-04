import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orth_news/app/router/app_routes.dart';
import 'package:orth_news/features/app_shell/view/app_shell.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/domain/repositories/news_repository.dart';
import 'package:orth_news/features/news/domain/usecases/get_top_headlines.dart';
import 'package:orth_news/features/news/domain/usecases/search_articles.dart';
import 'package:orth_news/features/news/presentation/bookmarks/view/bookmarks_page.dart';
import 'package:orth_news/features/news/presentation/detail/article_route_args.dart';
import 'package:orth_news/features/news/presentation/detail/view/article_detail_page.dart';
import 'package:orth_news/features/news/presentation/home/bloc/home_bloc.dart';
import 'package:orth_news/features/news/presentation/home/view/home_page.dart';
import 'package:orth_news/features/news/presentation/search/bloc/search_bloc.dart';
import 'package:orth_news/features/news/presentation/search/view/search_page.dart';
import 'package:orth_news/features/settings/presentation/view/settings_page.dart';

GoRouter createRouter() {
  final rootKey = GlobalKey<NavigatorState>();

  return GoRouter(
    initialLocation: AppRoutes.home,
    navigatorKey: rootKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => BlocProvider(
                  create: (context) => HomeBloc(
                    getTopHeadlines: GetTopHeadlines(
                      context.read<NewsRepository>(),
                    ),
                  )..add(const HomeStarted()),
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.bookmarks,
                builder: (context, state) => const BookmarksPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.search,
        parentNavigatorKey: rootKey,
        builder: (context, state) => BlocProvider(
          create: (context) => SearchBloc(
            searchArticles: SearchArticles(context.read<NewsRepository>()),
          ),
          child: const SearchPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.article,
        parentNavigatorKey: rootKey,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is ArticleRouteArgs) {
            return ArticleDetailPage(
              article: extra.article,
              heroTag: extra.heroTag,
            );
          }
          if (extra is Article) {
            return ArticleDetailPage(article: extra);
          }
          return const Scaffold(
            body: Center(child: Text('Article unavailable')),
          );
        },
      ),
    ],
  );
}
