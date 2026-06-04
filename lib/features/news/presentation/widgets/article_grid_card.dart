import 'package:flutter/material.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/widgets/article_image.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/presentation/widgets/source_label.dart';

/// 2-column card for the feed's grid layout. The kit ships only a list, so this
/// mirrors its styling at card scale.
class ArticleGridCard extends StatelessWidget {
  const ArticleGridCard({
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
      borderRadius: BorderRadius.circular(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ArticleImage(
            url: article.imageUrl,
            width: double.infinity,
            height: 112,
            borderRadius: 14,
          ),
          const SizedBox(height: 10),
          Text(
            article.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.text.titleSmall,
          ),
          const SizedBox(height: 9),
          SourceLabel(article: article),
        ],
      ),
    );
  }
}
