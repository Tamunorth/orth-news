import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orth_news/app/router/app_routes.dart';
import 'package:orth_news/features/app_shell/view/app_shell.dart';
import 'package:orth_news/features/article_detail/presentation/view/article_detail_page.dart';
import 'package:orth_news/features/bookmarks/presentation/view/bookmarks_page.dart';
import 'package:orth_news/features/headlines/presentation/bloc/headlines_bloc.dart';
import 'package:orth_news/features/headlines/presentation/view/headlines_page.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/domain/repositories/news_repository.dart';
import 'package:orth_news/features/news/domain/usecases/get_top_headlines.dart';
import 'package:orth_news/features/news/domain/usecases/search_articles.dart';
import 'package:orth_news/features/search/presentation/bloc/search_bloc.dart';
import 'package:orth_news/features/search/presentation/view/search_page.dart';
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
                  create: (context) => HeadlinesBloc(
                    getTopHeadlines: GetTopHeadlines(
                      context.read<NewsRepository>(),
                    ),
                  )..add(const HeadlinesStarted()),
                  child: const HeadlinesPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                builder: (context, state) => BlocProvider(
                  create: (context) => SearchBloc(
                    searchArticles: SearchArticles(
                      context.read<NewsRepository>(),
                    ),
                  ),
                  child: const SearchPage(),
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
        path: AppRoutes.article,
        parentNavigatorKey: rootKey,
        builder: (context, state) {
          final article = state.extra;
          if (article is! Article) {
            return const Scaffold(
              body: Center(child: Text('Article unavailable')),
            );
          }
          return ArticleDetailPage(article: article);
        },
      ),
    ],
  );
}
