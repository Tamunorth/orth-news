import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orth_news/core/enums.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/features/settings/presentation/bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          _SettingsRow(
            icon: Icons.dark_mode_outlined,
            label: l10n.settingsDarkMode,
            trailing: Switch.adaptive(
              value: isDark,
              activeTrackColor: colors.accent,
              onChanged: (on) => context.read<SettingsBloc>().add(
                SettingsThemeModeChanged(
                  on ? ThemeMode.dark : ThemeMode.light,
                ),
              ),
            ),
          ),
          _SettingsRow(
            icon: Icons.view_agenda_outlined,
            label: l10n.settingsDefaultLayout,
            trailing: BlocBuilder<SettingsBloc, SettingsState>(
              buildWhen: (p, c) => p.defaultLayout != c.defaultLayout,
              builder: (context, state) => _LayoutSegmented(
                value: state.defaultLayout,
                onChanged: (layout) => context.read<SettingsBloc>().add(
                  SettingsDefaultLayoutChanged(layout),
                ),
              ),
            ),
          ),
          _SectionLabel(l10n.settingsAbout),
          _SettingsRow(
            icon: Icons.info_outline_rounded,
            label: l10n.appTitle,
            trailingText: 'v1.0.0',
          ),
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

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.trailing,
    this.trailingText,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.line)),
      ),
      child: Row(
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
          if (trailing != null)
            trailing!
          else if (trailingText != null)
            Text(
              trailingText!,
              style: context.text.bodyMedium?.copyWith(color: colors.muted),
            ),
        ],
      ),
    );
  }
}

class _LayoutSegmented extends StatelessWidget {
  const _LayoutSegmented({required this.value, required this.onChanged});

  final FeedLayout value;
  final ValueChanged<FeedLayout> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.field,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _segment(
            context,
            context.l10n.layoutList,
            value == FeedLayout.list,
            () {
              onChanged(FeedLayout.list);
            },
          ),
          _segment(
            context,
            context.l10n.layoutGrid,
            value == FeedLayout.grid,
            () {
              onChanged(FeedLayout.grid);
            },
          ),
        ],
      ),
    );
  }

  Widget _segment(
    BuildContext context,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    final colors = context.colors;
    return GestureDetector(
      onTap: active ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? colors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          label,
          style: context.text.labelMedium?.copyWith(
            color: active ? colors.onAccent : colors.body,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
