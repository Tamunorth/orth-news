import 'package:flutter/foundation.dart';

/// Lets the home search bar ask the Search page to focus its field. [pending]
/// covers the first visit (where the page's listener registers after the
/// request fires); [signal] covers repeat visits while the page is kept alive.
class SearchFocus {
  SearchFocus._();

  static final instance = SearchFocus._();

  final ValueNotifier<int> signal = ValueNotifier<int>(0);

  bool pending = false;

  void request() {
    pending = true;
    signal.value++;
  }

  void consume() => pending = false;
}
