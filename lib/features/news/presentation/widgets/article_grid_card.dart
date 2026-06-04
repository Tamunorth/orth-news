import 'package:flutter/material.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/core/widgets/article_image.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/presentation/widgets/bookmark_button.dart';
import 'package:orth_news/features/news/presentation/widgets/source_label.dart';

/// Fixed grid-cell height: thumbnail + 2-line title + 2-line description
/// + source row, sized to avoid overflow.
const double kArticleGridCardExtent = 296;

/// 2-column card for the feed's grid layout, with the bookmark overlaid on the
/// image so it's reachable from grid view too.
class ArticleGridCard extends StatelessWidget {
  const ArticleGridCard({
    required this.article,
    required this.onTap,
    this.heroTag,
    super.key,
  });

  final Article article;
  final VoidCallback onTap;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final description = article.description?.trim();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ArticleImage(
                url: article.imageUrl,
                width: double.infinity,
                height: 112,
                borderRadius: 14,
                heroTag: heroTag,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.88),
                    shape: BoxShape.circle,
                  ),
                  child: BookmarkButton(article: article, size: 17),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            article.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.text.titleSmall,
          ),
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.text.bodySmall?.copyWith(color: colors.body),
            ),
          ],
          const SizedBox(height: 9),
          SourceLabel(article: article),
        ],
      ),
    );
  }
}
