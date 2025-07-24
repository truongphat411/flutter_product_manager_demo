import 'dart:io';

import '../../../data/models/models.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> fetchProducts({
    String? keyword,
    int? categoryId,
  });
  Future<ProductModel> getProductById({
    required int productId,
  });
  Future<void> createProduct({
    required ProductModel product,
  });
  Future<void> updateProduct({
    required ProductModel product,
  });
  Future<void> deleteProduct({
    required int productId,
  });
  Future<void> uploadProductImages({
    required int productId,
    required List<File> imageFiles,
  });
}
