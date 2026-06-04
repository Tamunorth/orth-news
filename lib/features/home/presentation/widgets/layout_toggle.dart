import 'package:flutter/material.dart';
import 'package:orth_news/core/enums.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/core/theme/app_radius.dart';

/// Two-icon segmented control for switching the feed between list and grid.
/// Tapping the inactive side flips the layout.
class LayoutToggle extends StatelessWidget {
  const LayoutToggle({required this.layout, required this.onToggle, super.key});

  final FeedLayout layout;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.field,
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Segment(
            icon: Icons.view_agenda_outlined,
            active: layout == FeedLayout.list,
            onToggle: onToggle,
          ),
          _Segment(
            icon: Icons.grid_view_rounded,
            active: layout == FeedLayout.grid,
            onToggle: onToggle,
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.icon,
    required this.active,
    required this.onToggle,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: active ? null : onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 34,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? colors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.segment),
        ),
        child: Icon(
          icon,
          size: 16,
          color: active ? colors.onAccent : colors.muted,
        ),
      ),
    );
  }
}
