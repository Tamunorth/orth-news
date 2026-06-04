import 'package:flutter/foundation.dart';

/// Lets the home search bar ask the Search page to focus its field, even on
/// repeat visits (the tab branch is kept alive by the shell, so `autofocus`
/// alone only fires once).
class SearchFocus {
  SearchFocus._();

  static final instance = SearchFocus._();

  final ValueNotifier<int> signal = ValueNotifier<int>(0);

  void request() => signal.value++;
}
