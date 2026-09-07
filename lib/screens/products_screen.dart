import 'package:flutter/material.dart';
import 'package:mini_shopping_app/widgets/product_widget.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';


class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.products.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (_, index) {
                return ProductCard(
                  product: provider.products[index],
                );
              },
            ),
    );
  }
}