import 'package:equatable/equatable.dart';

/// Domain-level error. The data layer maps every exception into one of these
/// so the rest of the app never sees `dio`/HTTP types.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'The request timed out.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'NewsAPI is having a moment.']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Invalid or missing API key.']);
}

class RateLimitFailure extends Failure {
  const RateLimitFailure([
    super.message = 'Daily request limit reached. Try again later.',
  ]);
}

class ClientFailure extends Failure {
  const ClientFailure([super.message = 'That request could not be completed.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not read local data.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong.']);
}
