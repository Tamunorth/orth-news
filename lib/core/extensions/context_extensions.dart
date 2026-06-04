import 'package:flutter/material.dart';
import 'package:orth_news/l10n/generated/app_localizations.dart';

extension ContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  TextTheme get text => Theme.of(this).textTheme;
}
