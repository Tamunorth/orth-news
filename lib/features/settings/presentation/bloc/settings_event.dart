part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class SettingsThemeModeChanged extends SettingsEvent {
  const SettingsThemeModeChanged(this.themeMode);

  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}

final class SettingsDefaultLayoutChanged extends SettingsEvent {
  const SettingsDefaultLayoutChanged(this.layout);

  final FeedLayout layout;

  @override
  List<Object?> get props => [layout];
}
