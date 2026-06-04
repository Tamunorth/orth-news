import 'package:flutter/material.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/core/widgets/article_image.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/presentation/widgets/source_label.dart';

/// The large "Trending" hero card at the top of the feed.
class FeaturedArticleCard extends StatelessWidget {
  const FeaturedArticleCard({
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
      borderRadius: BorderRadius.circular(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ArticleImage(
            url: article.imageUrl,
            width: double.infinity,
            height: 190,
            borderRadius: 18,
            heroTag: heroTag,
          ),
          const SizedBox(height: 13),
          Text(
            article.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.text.titleMedium,
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
          const SizedBox(height: 11),
          SourceLabel(article: article),
        ],
      ),
    );
  }
}
