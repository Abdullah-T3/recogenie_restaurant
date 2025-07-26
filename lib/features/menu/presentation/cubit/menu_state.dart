part of 'menu_cubit.dart';

@immutable
sealed class MenuState {}

final class MenuInitial extends MenuState {}

final class MenuLoading extends MenuState {}

final class MenuSuccess extends MenuState {
  final List<MenuItem> menuItems;
  MenuSuccess(this.menuItems);
}

final class MenuFailure extends MenuState {
  final String message;
  MenuFailure(this.message);
}
