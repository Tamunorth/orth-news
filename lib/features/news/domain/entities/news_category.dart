/// The seven categories NewsAPI's `top-headlines` endpoint accepts. `general`
/// is surfaced as "All" in the UI.
enum NewsCategory {
  general,
  business,
  entertainment,
  health,
  science,
  sports,
  technology
  ;

  /// Value passed to NewsAPI's `category` query parameter.
  String get apiValue => name;
}
