import 'package:flutter/material.dart';

/// Semantic monochrome palette, taken from the News App UI Kit with its blue
/// accent stripped to near-black. Exposed as a [ThemeExtension] so widgets read
/// intent (`context.colors.title`) rather than raw hex.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.field,
    required this.title,
    required this.body,
    required this.muted,
    required this.line,
    required this.accent,
    required this.onAccent,
  });

  final Color background;
  final Color surface;
  final Color field;
  final Color title;
  final Color body;
  final Color muted;
  final Color line;
  final Color accent;
  final Color onAccent;

  static const light = AppColors(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    field: Color(0xFFF1F1F6),
    title: Color(0xFF050505),
    body: Color(0xFF4E4B66),
    muted: Color(0xFFA0A3BD),
    line: Color(0xFFECECF2),
    accent: Color(0xFF0A0A0A),
    onAccent: Color(0xFFFFFFFF),
  );

  static const dark = AppColors(
    background: Color(0xFF0C0C0E),
    surface: Color(0xFF161619),
    field: Color(0xFF1C1C20),
    title: Color(0xFFFFFFFF),
    body: Color(0xFFC5C5D0),
    muted: Color(0xFF67677A),
    line: Color(0xFF242429),
    accent: Color(0xFFFFFFFF),
    onAccent: Color(0xFF0C0C0E),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? field,
    Color? title,
    Color? body,
    Color? muted,
    Color? line,
    Color? accent,
    Color? onAccent,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      field: field ?? this.field,
      title: title ?? this.title,
      body: body ?? this.body,
      muted: muted ?? this.muted,
      line: line ?? this.line,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      field: Color.lerp(field, other.field, t)!,
      title: Color.lerp(title, other.title, t)!,
      body: Color.lerp(body, other.body, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      line: Color.lerp(line, other.line, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
