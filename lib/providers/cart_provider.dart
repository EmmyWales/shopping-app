import 'package:flutter/material.dart';

import '../data/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get total {
    return product.price * quantity;
  }
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount {
    int count = 0;

    for (final item in _items) {
      count += item.quantity;
    }

    return count;
  }

  double get totalPrice {
    double total = 0;

    for (final item in _items) {
      total += item.total;
    }

    return total;
  }

  void addToCart(Product product) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(
        CartItem(product: product),
      );
    }

    notifyListeners();
  }

  void removeFromCart(Product product) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex].quantity--;
      } else {
        _items.removeAt(existingIndex);
      }
    }

    notifyListeners();
  }

  void removeItem(Product product) {
    _items.removeWhere(
      (item) => item.product.id == product.id,
    );

    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}