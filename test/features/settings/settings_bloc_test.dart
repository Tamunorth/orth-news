import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orth_news/core/enums.dart';
import 'package:orth_news/features/settings/presentation/bloc/settings_bloc.dart';

class _MockStorage extends Mock implements Storage {}

void main() {
  setUp(() {
    final storage = _MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  blocTest<SettingsBloc, SettingsState>(
    'changes the theme mode',
    build: SettingsBloc.new,
    act: (bloc) => bloc.add(const SettingsThemeModeChanged(ThemeMode.dark)),
    expect: () => [
      isA<SettingsState>().having((s) => s.themeMode, 'theme', ThemeMode.dark),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'changes the default layout',
    build: SettingsBloc.new,
    act: (bloc) =>
        bloc.add(const SettingsDefaultLayoutChanged(FeedLayout.grid)),
    expect: () => [
      isA<SettingsState>().having(
        (s) => s.defaultLayout,
        'layout',
        FeedLayout.grid,
      ),
    ],
  );
}
