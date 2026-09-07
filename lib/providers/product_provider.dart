import 'package:flutter/material.dart';
import 'package:mini_shopping_app/data/mock_product.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];

  bool _isLoading = false;

  List<Product> get products => _products;

  bool get isLoading => _isLoading;

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    _products = mockProducts;

    _isLoading = false;
    notifyListeners();
  }

  Product? getProductById(int id) {
    try {
      return _products.firstWhere(
        (product) => product.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}