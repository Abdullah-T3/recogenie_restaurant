import '../../data/models/cart_item.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double totalPrice;

  CartLoaded({required this.items, required this.totalPrice});
}

class CartLoading extends CartState {}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}
