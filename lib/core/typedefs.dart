import 'package:fpdart/fpdart.dart';
import 'package:orth_news/core/error/failure.dart';

/// The result of any repository call: a [Failure] on the left, data on the
/// right.
typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef DataMap = Map<String, dynamic>;
