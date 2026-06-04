import 'package:flutter_test/flutter_test.dart';
import 'package:orth_news/features/news/data/models/article_model.dart';

void main() {
  group('ArticleModel.fromJson', () {
    test('parses a full article and strips the truncation marker', () {
      final article = ArticleModel.fromJson(const {
        'source': {'id': 'bbc-news', 'name': 'BBC News'},
        'author': 'Jane Doe',
        'title': 'Headline',
        'description': 'A short description.',
        'url': 'https://example.com/a',
        'urlToImage': 'https://example.com/a.jpg',
        'publishedAt': '2026-06-03T03:50:00Z',
        'content': 'Body text here [+2317 chars]',
      });

      expect(article.title, 'Headline');
      expect(article.sourceName, 'BBC News');
      expect(article.sourceId, 'bbc-news');
      expect(article.imageUrl, 'https://example.com/a.jpg');
      expect(article.content, 'Body text here');
      expect(article.isRemoved, isFalse);
    });

    test('tolerates the many nullable fields', () {
      final article = ArticleModel.fromJson(const {
        'source': {'id': null, 'name': 'NBC'},
        'author': null,
        'title': 'Title only',
        'description': null,
        'url': 'https://x.com',
        'urlToImage': null,
        'publishedAt': '2026-06-03T03:50:00Z',
        'content': null,
      });

      expect(article.sourceId, isNull);
      expect(article.imageUrl, isNull);
      expect(article.description, isNull);
      expect(article.author, isNull);
    });

    test('flags retracted "[Removed]" articles', () {
      final article = ArticleModel.fromJson(const {
        'source': {'id': null, 'name': '[Removed]'},
        'title': '[Removed]',
        'url': 'https://removed.com',
        'publishedAt': '2026-06-03T03:50:00Z',
      });

      expect(article.isRemoved, isTrue);
    });

    test('round-trips through toJson', () {
      final original = ArticleModel.fromJson(const {
        'source': {'id': 'cnn', 'name': 'CNN'},
        'author': 'A. Reporter',
        'title': 'Title',
        'description': 'Desc',
        'url': 'https://u.com',
        'urlToImage': 'https://i.com/x.jpg',
        'publishedAt': '2026-06-03T03:50:00Z',
        'content': 'Content',
      });

      final restored = ArticleModel.fromJson(original.toJson());
      expect(restored, equals(original));
    });
  });
}
