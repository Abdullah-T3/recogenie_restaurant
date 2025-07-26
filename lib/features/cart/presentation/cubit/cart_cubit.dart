import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/repo/cart_repository.dart';
import '../../data/models/cart_item.dart';
import 'cart_state.dart';

@singleton
class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;

  CartCubit(this._cartRepository) : super(CartInitial()) {
    _loadCart();
  }

  void _loadCart() {
    emit(
      CartLoaded(
        items: _cartRepository.cartItems,
        totalPrice: _cartRepository.totalPrice,
      ),
    );
  }

  void addToCart(CartItem item) {
    _cartRepository.addToCart(item);
    _loadCart();
  }

  void removeFromCart(String id) {
    _cartRepository.removeFromCart(id);
    _loadCart();
  }

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeFromCart(id);
    } else {
      _cartRepository.updateQuantity(id, quantity);
      _loadCart();
    }
  }

  void clearCart() {
    _cartRepository.clearCart();
    _loadCart();
  }

  void addMenuItemToCart({
    required String id,
    required String name,
    required double price,
    String? imageUrl,
    int quantity = 1,
  }) {
    final cartItem = CartItem(
      id: id,
      name: name,
      price: price,
      imageUrl: imageUrl,
      quantity: quantity,
    );
    addToCart(cartItem);
  }
}
