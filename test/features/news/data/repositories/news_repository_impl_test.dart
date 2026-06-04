import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orth_news/core/error/exceptions.dart';
import 'package:orth_news/core/error/failure.dart';
import 'package:orth_news/features/news/data/datasources/news_remote_data_source.dart';
import 'package:orth_news/features/news/data/models/article_model.dart';
import 'package:orth_news/features/news/data/repositories/news_repository_impl.dart';
import 'package:orth_news/features/news/domain/entities/news_category.dart';

class _MockRemote extends Mock implements NewsRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late NewsRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = NewsRepositoryImpl(remote);
  });

  final articles = [
    ArticleModel(title: 'T', url: 'u', publishedAt: DateTime(2026)),
  ];

  void stub({Object? throws, List<ArticleModel>? returns}) {
    final stubbed = when(
      () => remote.getTopHeadlines(
        category: any(named: 'category'),
        page: any(named: 'page'),
        country: any(named: 'country'),
      ),
    );
    if (throws != null) {
      stubbed.thenThrow(throws);
    } else {
      stubbed.thenAnswer((_) async => returns ?? <ArticleModel>[]);
    }
  }

  DioException dio(DioExceptionType type, {int? status}) => DioException(
    requestOptions: RequestOptions(),
    type: type,
    response: status == null
        ? null
        : Response<dynamic>(
            requestOptions: RequestOptions(),
            statusCode: status,
          ),
  );

  group('getTopHeadlines maps results', () {
    test('returns Right on success', () async {
      stub(returns: articles);
      final result = await repository.getTopHeadlines(
        category: NewsCategory.general,
        page: 1,
      );
      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected Right'), (a) => expect(a.length, 1));
    });

    test('401 ApiException -> UnauthorizedFailure', () async {
      stub(throws: const ApiException(message: 'bad key', statusCode: 401));
      final result = await repository.getTopHeadlines(
        category: NewsCategory.general,
        page: 1,
      );
      result.fold(
        (f) => expect(f, isA<UnauthorizedFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('429 ApiException -> RateLimitFailure', () async {
      stub(throws: const ApiException(message: 'rate', statusCode: 429));
      final result = await repository.getTopHeadlines(
        category: NewsCategory.general,
        page: 1,
      );
      result.fold(
        (f) => expect(f, isA<RateLimitFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('receive timeout -> TimeoutFailure', () async {
      stub(throws: dio(DioExceptionType.receiveTimeout));
      final result = await repository.getTopHeadlines(
        category: NewsCategory.general,
        page: 1,
      );
      result.fold(
        (f) => expect(f, isA<TimeoutFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('connection error -> NetworkFailure', () async {
      stub(throws: dio(DioExceptionType.connectionError));
      final result = await repository.getTopHeadlines(
        category: NewsCategory.general,
        page: 1,
      );
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('expected Left'),
      );
    });
  });
}
