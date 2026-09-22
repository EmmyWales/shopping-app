import 'package:flutter/material.dart';
import 'package:mini_shopping_app/data/models/product.dart';
import 'package:mini_shopping_app/services/product_api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductApiService _apiService = ProductApiService();

  List<Product> _products = [];

  bool _isLoading = false;

  String? _error;

  List<Product> get products => _products;

  bool get isLoading => _isLoading;

  String? get error => _error;


  

  Future<void> loadProducts() async {
    print('START loading products');
    _isLoading = true;
    _error = null;
    print('Products received: ${_products.length}');

    notifyListeners();

    try {
      final products = await _apiService.fetchProducts();

      print('API returned ${products.length} products');
      _products = products;

      print('Provider now has ${_products.length} products');
    } catch (e) {
      print('API ERROR: $e');

      _error = e.toString();
    } finally {
      _isLoading = false;

      notifyListeners();
      print('FINISHED loading products');
    }
  }

  Product? getProductById(int id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}
