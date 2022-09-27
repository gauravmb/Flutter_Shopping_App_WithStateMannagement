import 'package:flutter/foundation.dart';

class CartItem {
  String id;
  String title;
  int quantity;
  double price;

  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = Map();

  int totalItems() {
    return _cartItems.length;
  }

  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }

  void addItemToCart(String productID, String title, double price) {
    if (_cartItems.containsKey(productID)) {
      _cartItems.update(
        productID,
        (cartItem) => CartItem(
            id: cartItem.id,
            price: cartItem.price,
            title: cartItem.title,
            quantity: cartItem.quantity + 1),
      );
    } else {
      _cartItems.putIfAbsent(
        productID,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    print(_cartItems);
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total = total + (value.price * value.quantity);
    });
    return total;
  }

  void removeItem(String productID) {
    _cartItems.remove(productID);
    notifyListeners();
  }

  void clear() {
    _cartItems = {};
    notifyListeners();
  }

  void removeSingleItem(String productID) {
    if (!_cartItems.containsKey(productID)) {
      return;
    }
    if (_cartItems[productID]!.quantity > 1) {
      _cartItems.update(
        productID,
        (value) => CartItem(
            id: value.id,
            price: value.price,
            title: value.title,
            quantity: value.quantity - 1),
      );
    } else {
      _cartItems.remove(productID);
    }
    notifyListeners();
  }
}
