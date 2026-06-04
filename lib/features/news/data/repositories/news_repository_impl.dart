import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:orth_news/core/error/exceptions.dart';
import 'package:orth_news/core/error/failure.dart';
import 'package:orth_news/core/typedefs.dart';
import 'package:orth_news/features/news/data/datasources/news_remote_data_source.dart';
import 'package:orth_news/features/news/domain/entities/article.dart';
import 'package:orth_news/features/news/domain/entities/news_category.dart';
import 'package:orth_news/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl(this._remote);

  final NewsRemoteDataSource _remote;

  @override
  ResultFuture<List<Article>> getTopHeadlines({
    required NewsCategory category,
    required int page,
  }) => _guard(
    () => _remote.getTopHeadlines(
      category: category.apiValue,
      page: page,
      country: 'us',
    ),
  );

  @override
  ResultFuture<List<Article>> searchArticles({
    required String query,
    required int page,
  }) => _guard(() => _remote.searchArticles(query: query, page: page));

  Future<Either<Failure, List<Article>>> _guard(
    Future<List<Article>> Function() request,
  ) async {
    try {
      return Right(await request());
    } on ApiException catch (e) {
      return Left(_mapApiException(e));
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } on Object catch (_) {
      return const Left(UnknownFailure());
    }
  }

  Failure _mapApiException(ApiException e) {
    final status = e.statusCode;
    if (status == 401) return UnauthorizedFailure(e.message);
    if (status == 426 || status == 429) return RateLimitFailure(e.message);
    if (status != null && status >= 500) return ServerFailure(e.message);
    return ClientFailure(e.message);
  }

  Failure _mapDioException(DioException e) => switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => const TimeoutFailure(),
    DioExceptionType.connectionError => const NetworkFailure(),
    DioExceptionType.badResponse =>
      (e.response?.statusCode ?? 0) >= 500
          ? const ServerFailure()
          : const ClientFailure(),
    DioExceptionType.cancel => const ClientFailure('Request cancelled.'),
    DioExceptionType.badCertificate ||
    DioExceptionType.unknown => const NetworkFailure(),
  };
}
