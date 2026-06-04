import 'package:flutter/material.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/widgets/article_image.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/presentation/widgets/source_label.dart';

/// The large "Trending" hero card at the top of the feed.
class FeaturedArticleCard extends StatelessWidget {
  const FeaturedArticleCard({
    required this.article,
    required this.onTap,
    super.key,
  });

  final Article article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
          ),
          const SizedBox(height: 13),
          Text(
            article.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.text.titleMedium,
          ),
          const SizedBox(height: 11),
          SourceLabel(article: article),
        ],
      ),
    );
  }
}
