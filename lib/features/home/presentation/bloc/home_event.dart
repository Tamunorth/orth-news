part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load of the current category (uses cache if present).
final class HomeStarted extends HomeEvent {
  const HomeStarted();
}

/// Pull-to-refresh: force a fresh fetch of the current category.
final class HomeRefreshed extends HomeEvent {
  const HomeRefreshed();
}

final class HomeCategoryChanged extends HomeEvent {
  const HomeCategoryChanged(this.category);

  final NewsCategory category;

  @override
  List<Object?> get props => [category];
}

/// Infinite-scroll: append the next page (capped at the free-tier limit).
final class HomeNextPageRequested extends HomeEvent {
  const HomeNextPageRequested();
}
