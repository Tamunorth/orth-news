import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/core/widgets/app_button.dart';
import 'package:orth_news/core/widgets/article_image.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/presentation/widgets/bookmark_button.dart';
import 'package:orth_news/features/news/presentation/widgets/source_label.dart';
import 'package:url_launcher/url_launcher.dart';

/// Full article view. NewsAPI has no article-by-id endpoint, so the [article]
/// is passed in via the router's `extra`. Body text is truncated by the API, so
/// we link out to the source for the full read.
class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({required this.article, super.key});

  final Article article;

  Future<void> _openOriginal(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.tryParse(article.url);
    final launched =
        uri != null &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open the article.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final body = [article.description, article.content]
        .where((s) => s != null && s.trim().isNotEmpty)
        .map((s) => s!.trim())
        .join('\n\n');

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 14),
                child: Row(
                  children: [
                    _CircleButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => context.pop(),
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.field,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: BookmarkButton(article: article, size: 22),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SourceLabel(article: article),
                    const SizedBox(height: 16),
                    ArticleImage(
                      url: article.imageUrl,
                      width: double.infinity,
                      height: 220,
                      borderRadius: 18,
                    ),
                    const SizedBox(height: 20),
                    Text(article.title, style: context.text.headlineSmall),
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        body,
                        style: context.text.bodyLarge?.copyWith(
                          color: colors.body,
                          height: 1.6,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    AppButton(
                      label: context.l10n.readFullArticle,
                      icon: Icons.north_east_rounded,
                      onPressed: () => _openOriginal(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.field,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 21, color: colors.title),
      ),
    );
  }
}
