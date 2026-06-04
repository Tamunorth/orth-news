import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:orth_news/core/enums.dart';

part 'settings_event.dart';
part 'settings_state.dart';

/// Persists theme + default feed layout across restarts.
class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SettingsThemeModeChanged>(
      (event, emit) => emit(state.copyWith(themeMode: event.themeMode)),
    );
    on<SettingsDefaultLayoutChanged>(
      (event, emit) => emit(state.copyWith(defaultLayout: event.layout)),
    );
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    final theme = json['themeMode'] as int?;
    final layout = json['defaultLayout'] as int?;
    return SettingsState(
      themeMode: _enumAt(ThemeMode.values, theme, ThemeMode.system),
      defaultLayout: _enumAt(FeedLayout.values, layout, FeedLayout.list),
    );
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) => {
    'themeMode': state.themeMode.index,
    'defaultLayout': state.defaultLayout.index,
  };

  static T _enumAt<T>(List<T> values, int? index, T fallback) =>
      (index != null && index >= 0 && index < values.length)
      ? values[index]
      : fallback;
}
