import 'package:flutter/material.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/core/utils/date_formatter.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';

/// Source row: a monochrome initial badge (NewsAPI gives no logos), the source
/// name, and a relative timestamp. Optional [trailing] for a bookmark action.
class SourceLabel extends StatelessWidget {
  const SourceLabel({required this.article, this.trailing, super.key});

  final Article article;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final source = article.sourceName?.trim();
    final name = (source != null && source.isNotEmpty)
        ? source
        : (article.author ?? 'Unknown');

    return Row(
      children: [
        _SourceBadge(label: name),
        const SizedBox(width: 7),
        Flexible(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.labelMedium?.copyWith(
              color: colors.title,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.schedule_rounded, size: 12, color: colors.muted),
        const SizedBox(width: 3),
        Text(
          timeAgo(article.publishedAt),
          style: context.text.labelSmall?.copyWith(color: colors.muted),
        ),
        if (trailing != null) ...[const Spacer(), trailing!],
      ],
    );
  }
}

class _SourceBadge extends StatelessWidget {
  const _SourceBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final initial = label.isNotEmpty
        ? label.substring(0, 1).toUpperCase()
        : '?';
    return Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle),
      child: Text(
        initial,
        style: context.text.labelSmall?.copyWith(
          color: colors.onAccent,
          fontWeight: FontWeight.w700,
          fontSize: 9,
          height: 1,
        ),
      ),
    );
  }
}
