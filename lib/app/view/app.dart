import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orth_news/app/router/app_router.dart';
import 'package:orth_news/core/config/app_config.dart';
import 'package:orth_news/core/network/dio_client.dart';
import 'package:orth_news/core/theme/app_theme.dart';
import 'package:orth_news/features/bookmarks/presentation/bloc/bookmarks_bloc.dart';
import 'package:orth_news/features/news/data/datasources/news_remote_data_source.dart';
import 'package:orth_news/features/news/data/repositories/news_repository_impl.dart';
import 'package:orth_news/features/news/domain/repositories/news_repository.dart';
import 'package:orth_news/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:orth_news/l10n/generated/app_localizations.dart';

class OrthNewsApp extends StatelessWidget {
  const OrthNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = NewsRepositoryImpl(
      NewsRemoteDataSourceImpl(buildDio(apiKey: AppConfig.newsApiKey)),
    );

    return RepositoryProvider<NewsRepository>.value(
      value: repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SettingsBloc()),
          BlocProvider(create: (_) => BookmarksBloc()),
        ],
        child: const _AppView(),
      ),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView();

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  late final GoRouter _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, settings) {
        return MaterialApp.router(
          title: 'Orth News',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.themeMode,
          routerConfig: _router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
