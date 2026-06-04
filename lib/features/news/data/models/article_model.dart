import 'package:orth_news/core/typedefs.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.title,
    required super.url,
    required super.publishedAt,
    super.description,
    super.content,
    super.imageUrl,
    super.author,
    super.sourceName,
    super.sourceId,
  });

  /// Parses the NewsAPI article shape. Nearly every field is nullable, and
  /// `content` carries a trailing `[+N chars]` truncation marker we strip.
  factory ArticleModel.fromJson(DataMap json) {
    final source = json['source'] as DataMap?;
    final parsed = DateTime.tryParse(json['publishedAt'] as String? ?? '');
    return ArticleModel(
      title: (json['title'] as String?)?.trim() ?? '',
      url: (json['url'] as String?) ?? '',
      publishedAt: (parsed ?? DateTime.fromMillisecondsSinceEpoch(0)).toLocal(),
      description: json['description'] as String?,
      content: _stripTruncationMarker(json['content'] as String?),
      imageUrl: json['urlToImage'] as String?,
      author: json['author'] as String?,
      sourceName: source?['name'] as String?,
      sourceId: source?['id'] as String?,
    );
  }

  factory ArticleModel.fromEntity(Article article) => ArticleModel(
    title: article.title,
    url: article.url,
    publishedAt: article.publishedAt,
    description: article.description,
    content: article.content,
    imageUrl: article.imageUrl,
    author: article.author,
    sourceName: article.sourceName,
    sourceId: article.sourceId,
  );

  /// Sources that retract an article still return it as a literal `[Removed]`.
  bool get isRemoved =>
      title.isEmpty || title == '[Removed]' || url == 'https://removed.com';

  /// Round-trips back to the NewsAPI shape so `fromJson` can re-read it — used
  /// for bookmark persistence.
  DataMap toJson() => {
    'source': {'id': sourceId, 'name': sourceName},
    'author': author,
    'title': title,
    'description': description,
    'url': url,
    'urlToImage': imageUrl,
    'publishedAt': publishedAt.toUtc().toIso8601String(),
    'content': content,
  };

  static String? _stripTruncationMarker(String? content) =>
      content?.replaceAll(RegExp(r'\s*\[\+\d+ chars\]$'), '');
}
