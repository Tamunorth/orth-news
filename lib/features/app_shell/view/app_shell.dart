import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';

/// Scaffold + custom monochrome bottom navigation that hosts the four tab
/// branches of [StatefulShellRoute].
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _BottomNav(shell: navigationShell),
    );
  }
}

class _Dest {
  const _Dest(this.icon, this.activeIcon, this.label);

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final destinations = <_Dest>[
      _Dest(Icons.home_outlined, Icons.home_rounded, l10n.navHome),
      _Dest(Icons.search_outlined, Icons.search_rounded, l10n.navSearch),
      _Dest(
        Icons.bookmark_border_rounded,
        Icons.bookmark_rounded,
        l10n.navSaved,
      ),
      _Dest(Icons.settings_outlined, Icons.settings_rounded, l10n.navSettings),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              for (var i = 0; i < destinations.length; i++)
                Expanded(
                  child: _NavButton(
                    dest: destinations[i],
                    active: shell.currentIndex == i,
                    onTap: () => shell.goBranch(
                      i,
                      initialLocation: i == shell.currentIndex,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.dest,
    required this.active,
    required this.onTap,
  });

  final _Dest dest;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = active ? colors.accent : colors.muted;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(active ? dest.activeIcon : dest.icon, size: 24, color: color),
          const SizedBox(height: 4),
          Text(
            dest.label,
            style: context.text.labelSmall?.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
