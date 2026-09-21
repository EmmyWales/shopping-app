class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int ratingCount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image'] ?? '',
      category: json['category'] ?? '',
      rating: (json['rating']?['rate'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['rating']?['count'] ?? 0,
    );
  }

  // factory Product.fromJson(Map<String, dynamic> json) {
  //   return Product(
  //     id: json['id'],
  //     name: json['name'],
  //     description: json['description'],
  //     price: (json['price'] as num).toDouble(),
  //     imageUrl: json['imageUrl'],
  //     category: json['category'],
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'description': description,
  //     'price': price,
  //     'imageUrl': imageUrl,
  //     'category': category,
  //   };
  // }
}
