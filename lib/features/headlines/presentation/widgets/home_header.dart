import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orth_news/app/router/app_routes.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';

/// Wordmark + bell + a search bar that jumps to the Search tab.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final brand = context.text.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 14),
      child: Column(
        children: [
          Row(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Orth', style: brand),
                    TextSpan(
                      text: 'News',
                      style: brand?.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const _CircleIcon(icon: Icons.notifications_none_rounded),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => context.go(AppRoutes.search),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: colors.field,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, size: 20, color: colors.muted),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      context.l10n.searchHint,
                      style: context.text.bodyMedium?.copyWith(
                        color: colors.muted,
                      ),
                    ),
                  ),
                  Container(width: 1, height: 20, color: colors.line),
                  const SizedBox(width: 12),
                  Icon(Icons.tune_rounded, size: 20, color: colors.muted),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.field,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 21, color: colors.title),
    );
  }
}
