/// Compile-time + static configuration.
///
/// [newsApiKey] is injected at build time via
/// `--dart-define-from-file=env.json` and read through a `const`
/// `String.fromEnvironment` so it is baked into the binary rather than
/// shipped as a readable asset.
abstract final class AppConfig {
  static const newsApiKey = String.fromEnvironment('NEWS_API_KEY');

  /// Default `top-headlines` country (ISO 3166-1 alpha-2).
  static const defaultCountry = 'us';

  static const pageSize = 20;

  /// NewsAPI free tier only exposes the first 100 results of any query.
  static const maxResults = 100;

  static const searchDebounce = Duration(milliseconds: 350);

  static bool get hasApiKey => newsApiKey.isNotEmpty;
}
