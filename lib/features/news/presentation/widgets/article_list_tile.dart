import 'package:flutter/material.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/core/widgets/article_image.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/presentation/widgets/source_label.dart';

/// Row item used by the feed, search and bookmarks lists: thumbnail, title
/// (2 lines), description (2 lines, per the brief), then the source row.
class ArticleListTile extends StatelessWidget {
  const ArticleListTile({
    required this.article,
    required this.onTap,
    this.trailing,
    super.key,
  });

  final Article article;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final description = article.description?.trim();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArticleImage(
              url: article.imageUrl,
              width: 84,
              height: 84,
              borderRadius: 14,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleSmall,
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.body,
                      ),
                    ),
                  ],
                  const SizedBox(height: 9),
                  SourceLabel(article: article, trailing: trailing),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
