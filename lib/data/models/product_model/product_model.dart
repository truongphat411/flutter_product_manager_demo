class ProductModel {
  final int id;
  final String name;
  final String description;
  final int price;
  final int stockQuantity;
  final int categoryId;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.categoryId,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stockQuantity: json['stock_quantity'],
      categoryId: json['category_id'],
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock_quantity': stockQuantity,
      'category_id': categoryId,
      'images': images,
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    int? price,
    int? stockQuantity,
    int? categoryId,
    List<String>? images,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      categoryId: categoryId ?? this.categoryId,
      images: images ?? this.images,
    );
  }
}
