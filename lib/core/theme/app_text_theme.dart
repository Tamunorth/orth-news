import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orth_news/core/theme/app_colors.dart';

/// Outfit drives display/headings, Poppins drives body and meta — the pairing
/// signed off in the presentation.
TextTheme buildTextTheme(AppColors c) {
  TextStyle display(
    double size,
    FontWeight weight, {
    double height = 1.2,
    Color? color,
  }) => GoogleFonts.outfit(
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: -0.2,
    color: color ?? c.title,
  );

  TextStyle text(
    double size,
    FontWeight weight, {
    double height = 1.5,
    Color? color,
  }) => GoogleFonts.poppins(
    fontSize: size,
    fontWeight: weight,
    height: height,
    color: color ?? c.body,
  );

  return TextTheme(
    displaySmall: display(32, FontWeight.w800, height: 1.05),
    headlineMedium: display(28, FontWeight.w700, height: 1.1),
    headlineSmall: display(22, FontWeight.w700, height: 1.22),
    titleLarge: display(20, FontWeight.w700),
    titleMedium: display(18, FontWeight.w600, height: 1.25),
    titleSmall: display(15, FontWeight.w600, height: 1.3),
    bodyLarge: text(15, FontWeight.w400),
    bodyMedium: text(13.5, FontWeight.w400),
    bodySmall: text(12, FontWeight.w400, height: 1.45),
    labelLarge: text(13.5, FontWeight.w600, height: 1.2, color: c.title),
    labelMedium: text(12, FontWeight.w500, height: 1.2),
    labelSmall: text(11, FontWeight.w500, height: 1.2),
  );
}
