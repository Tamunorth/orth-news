import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orth_news/core/enums.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/core/widgets/segmented_control.dart';
import 'package:orth_news/features/settings/presentation/bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.settingsTitle,
                style: context.text.headlineMedium,
              ),
            ),
          ),
          _SectionLabel(l10n.settingsAppearance),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              final bloc = context.read<SettingsBloc>();
              return Column(
                children: [
                  _ControlTile(
                    icon: Icons.brightness_6_outlined,
                    label: l10n.settingsTheme,
                    control: SegmentedControl<ThemeMode>(
                      expand: true,
                      value: state.themeMode,
                      onChanged: (mode) =>
                          bloc.add(SettingsThemeModeChanged(mode)),
                      options: [
                        SegmentOption(ThemeMode.system, l10n.themeSystem),
                        SegmentOption(ThemeMode.dark, l10n.themeDark),
                        SegmentOption(ThemeMode.light, l10n.themeLight),
                      ],
                    ),
                  ),
                  _ControlTile(
                    icon: Icons.view_agenda_outlined,
                    label: l10n.settingsDefaultLayout,
                    control: SegmentedControl<FeedLayout>(
                      expand: true,
                      value: state.defaultLayout,
                      onChanged: (layout) =>
                          bloc.add(SettingsDefaultLayoutChanged(layout)),
                      options: [
                        SegmentOption(FeedLayout.list, l10n.layoutList),
                        SegmentOption(FeedLayout.grid, l10n.layoutGrid),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          _SectionLabel(l10n.settingsAbout),
          _ControlTile.about(label: l10n.appTitle, version: 'v1.0.0'),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      child: Text(
        label.toUpperCase(),
        style: context.text.labelSmall?.copyWith(
          color: context.colors.muted,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ControlTile extends StatelessWidget {
  const _ControlTile({
    required this.icon,
    required this.label,
    required this.control,
  }) : value = null;

  const _ControlTile.about({required this.label, required String version})
    : icon = Icons.info_outline_rounded,
      control = null,
      value = version;

  final IconData icon;
  final String label;
  final Widget? control;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.field,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 19, color: colors.title),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  label,
                  style: context.text.bodyLarge?.copyWith(
                    color: colors.title,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (value != null)
                Text(
                  value!,
                  style: context.text.bodyMedium?.copyWith(color: colors.muted),
                ),
            ],
          ),
          if (control != null) ...[const SizedBox(height: 12), control!],
        ],
      ),
    );
  }
}
