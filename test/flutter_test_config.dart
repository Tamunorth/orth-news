import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

/// Runs for every test in the suite: stop google_fonts from hitting the network
/// (it falls back to a bundled/system font instead).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  await testMain();
}
