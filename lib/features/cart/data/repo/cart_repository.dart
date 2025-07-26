import '../models/cart_item.dart';
import 'package:injectable/injectable.dart';

@singleton
class CartRepository {
  final List<CartItem> _cart = [];

  List<CartItem> get cartItems => List.unmodifiable(_cart);

  void addToCart(CartItem item) {
    final index = _cart.indexWhere((e) => e.id == item.id);
    if (index == -1) {
      _cart.add(item);
    } else {
      _cart[index].quantity += item.quantity;
    }
  }

  void removeFromCart(String id) {
    _cart.removeWhere((item) => item.id == id);
  }

  void updateQuantity(String id, int quantity) {
    final index = _cart.indexWhere((e) => e.id == id);
    if (index != -1) {
      _cart[index].quantity = quantity;
    }
  }

  void clearCart() {
    _cart.clear();
  }

  double get totalPrice =>
      _cart.fold(0, (sum, item) => sum + item.price * item.quantity);
}
