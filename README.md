# Orth News

A monochrome news reader on [NewsAPI](https://newsapi.org). Flutter · clean
architecture · BLoC.

## Run

The API key is injected at build time and never committed:

1. `cp env.example.json env.json` and add your newsapi.org key.
2. `flutter pub get`
3. `flutter run --dart-define-from-file=env.json`

> NewsAPI's free tier works from mobile/localhost only (CORS blocks the web
> build), serves articles ~24h delayed, allows 100 requests/day, and caps any
> query at 100 results — the feed paginates to that limit by design.

## Architecture

`data → domain → presentation`, feature-first under `lib/features`:

- **data** — `ArticleModel` (NewsAPI parsing, `[Removed]`/null defence,
  round-trip JSON for bookmarks), `NewsRemoteDataSource` (dio),
  `NewsRepositoryImpl` (maps `DioException`/`ApiException` → typed `Failure`).
  The only layer that imports dio.
- **domain** — `Article` entity, `NewsRepository` interface, and the use-cases
  `GetTopHeadlines` / `SearchArticles` returning `Either<Failure, T>` (fpdart).
  No Flutter or dio imports.
- **presentation** — Blocs (the view-models) depend only on use-cases, plus
  widgets.

State management is BLoC throughout: `HeadlinesBloc`, `SearchBloc` (debounced
via a `restartable` `EventTransformer`), and hydrated `BookmarksBloc` +
`SettingsBloc` that survive restarts. Routing is GoRouter
(`StatefulShellRoute`); theming is Material 3 light/dark with Outfit + Poppins.

## Features

Feed with list/grid toggle (trending hero + category chips), article detail,
search, bookmarks, and settings (dark mode + default layout). Loading, error and
empty states are handled on every screen.

## Test

```sh
flutter test
```

Unit tests cover the model, the repository's failure mapping, and all four
blocs; widget tests cover the feed tile and the layout toggle.
