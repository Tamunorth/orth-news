import 'package:equatable/equatable.dart';

/// A news article. NewsAPI has no stable id, so [url] is the natural identity
/// used for de-duplication and bookmark equality.
class Article extends Equatable {
  const Article({
    required this.title,
    required this.url,
    required this.publishedAt,
    this.description,
    this.content,
    this.imageUrl,
    this.author,
    this.sourceName,
    this.sourceId,
  });

  final String title;
  final String url;
  final DateTime publishedAt;
  final String? description;
  final String? content;
  final String? imageUrl;
  final String? author;
  final String? sourceName;
  final String? sourceId;

  @override
  List<Object?> get props => [
    url,
    title,
    publishedAt,
    description,
    content,
    imageUrl,
    author,
    sourceName,
    sourceId,
  ];
}
