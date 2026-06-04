part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.defaultLayout = FeedLayout.list,
  });

  final ThemeMode themeMode;
  final FeedLayout defaultLayout;

  SettingsState copyWith({ThemeMode? themeMode, FeedLayout? defaultLayout}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      defaultLayout: defaultLayout ?? this.defaultLayout,
    );
  }

  @override
  List<Object?> get props => [themeMode, defaultLayout];
}
