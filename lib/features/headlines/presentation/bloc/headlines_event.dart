part of 'headlines_bloc.dart';

sealed class HeadlinesEvent extends Equatable {
  const HeadlinesEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load of the current category's first page.
final class HeadlinesStarted extends HeadlinesEvent {
  const HeadlinesStarted();
}

/// Pull-to-refresh: reload the first page.
final class HeadlinesRefreshed extends HeadlinesEvent {
  const HeadlinesRefreshed();
}

final class HeadlinesCategoryChanged extends HeadlinesEvent {
  const HeadlinesCategoryChanged(this.category);

  final NewsCategory category;

  @override
  List<Object?> get props => [category];
}

/// Infinite-scroll: append the next page (capped at the free-tier limit).
final class HeadlinesNextPageRequested extends HeadlinesEvent {
  const HeadlinesNextPageRequested();
}

final class HeadlinesLayoutToggled extends HeadlinesEvent {
  const HeadlinesLayoutToggled();
}
