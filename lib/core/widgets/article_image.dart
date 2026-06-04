import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orth_news/core/theme/app_colors.dart';

/// Network image with a monochrome placeholder. NewsAPI's `urlToImage` is often
/// null or points at a dead host, so we guard null before building and keep an
/// error fallback.
class ArticleImage extends StatelessWidget {
  const ArticleImage({
    required this.url,
    this.width,
    this.height,
    this.borderRadius = 12,
    super.key,
  });

  final String? url;
  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fallback = ColoredBox(
      color: colors.field,
      child: Center(
        child: Icon(Icons.image_outlined, color: colors.muted, size: 22),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: (url == null || url!.isEmpty)
            ? fallback
            : CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                placeholder: (_, _) => fallback,
                errorWidget: (_, _, _) => fallback,
              ),
      ),
    );
  }
}
