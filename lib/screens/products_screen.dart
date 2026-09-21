import 'package:flutter/material.dart';
import 'package:mini_shopping_app/widgets/product_widget.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';


class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => context.read<ProductProvider>().loadProducts(),
    );
  }

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
          : provider.error != null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 50,
                ),

                const SizedBox(height: 16),

                Text(
                  provider.error!,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: provider.loadProducts,
                  child: const Text('Try Again'),
                ),
              ],
            ),
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