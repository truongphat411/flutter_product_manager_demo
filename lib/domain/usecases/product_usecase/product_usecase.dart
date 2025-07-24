import 'dart:io';

import '../../../data/models/models.dart';
import '../../repositories/repositories.dart';

class ProductUseCase {
  final ProductRepository repository;

  ProductUseCase({
    required this.repository,
  });

  Future<List<ProductModel>> fetchProducts({
    String? keyword,
    int? categoryId,
  }) async {
    return await repository.fetchProducts(
      categoryId: categoryId,
      keyword: keyword,
    );
  }

  Future<ProductModel> getProductById({
    required int productId,
  }) async {
    return await repository.getProductById(
      productId: productId,
    );
  }

  Future<void> createProduct({
    required ProductModel product,
  }) async {
    return await repository.createProduct(
      product: product,
    );
  }

  Future<void> updateProduct({
    required ProductModel product,
  }) async {
    return await repository.updateProduct(
      product: product,
    );
  }

  Future<void> deleteProduct({
    required int productId,
  }) async {
    return await repository.deleteProduct(
      productId: productId,
    );
  }

  Future<void> uploadProductImages({
    required int productId,
    required List<File> imageFiles,
  }) async {
    return await repository.uploadProductImages(
      productId: productId,
      imageFiles: imageFiles,
    );
  }
}
