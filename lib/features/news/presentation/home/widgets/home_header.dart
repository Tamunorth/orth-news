import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orth_news/app/router/app_routes.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/core/theme/app_radius.dart';

/// Wordmark + a search bar that pushes the full-screen Search route.
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => context.push(AppRoutes.search),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: colors.field,
                borderRadius: BorderRadius.circular(AppRadius.field),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
