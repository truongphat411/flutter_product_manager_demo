import 'dart:io';

import 'package:flutter_product_manager_demo/data/models/models.dart';

import '../../../core/services/network/network_info.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/local/local.dart';
import '../../datasources/remote/remote.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<ProductModel>> fetchProducts({
    String? keyword,
    int? categoryId,
  }) async {
    final isConnected = await NetworkInfo.instance.isConnected;
    if (isConnected) {
      try {
        final remoteProducts = await remoteDataSource.fetchProducts(
          categoryId: categoryId,
          keyword: keyword,
        );
        await localDataSource.cacheProducts(remoteProducts);
        return remoteProducts;
      } catch (_) {
        return await localDataSource.getCachedProducts();
      }
    } else {
      return await localDataSource.getCachedProducts();
    }
  }

  @override
  Future<ProductModel> getProductById({
    required int productId,
  }) async {
    final isConnected = await NetworkInfo.instance.isConnected;
    if (isConnected) {
      return await remoteDataSource.getProductByID(productId: productId);
    } else {
      return await localDataSource.getProductByID(productId);
    }
  }

  @override
  Future<void> createProduct({
    required ProductModel product,
  }) async {
    final isConnected = await NetworkInfo.instance.isConnected;
    if (isConnected) {
      await remoteDataSource.createProduct(product: product);
    } else {
      throw Exception('Không có kết nối mạng để tạo sản phẩm');
    }
  }

  @override
  Future<void> updateProduct({
    required ProductModel product,
  }) async {
    final isConnected = await NetworkInfo.instance.isConnected;
    if (isConnected) {
      await remoteDataSource.updateProduct(product: product);
    } else {
      throw Exception('Không có mạng để cập nhật sản phẩm');
    }
  }

  @override
  Future<void> deleteProduct({
    required int productId,
  }) async {
    final isConnected = await NetworkInfo.instance.isConnected;
    if (isConnected) {
      await remoteDataSource.deleteProduct(productId: productId);
    } else {
      throw Exception('Không có mạng để xoá sản phẩm');
    }
  }

  @override
  Future<void> uploadProductImages({
    required int productId,
    required List<File> imageFiles,
  }) async {
    final isConnected = await NetworkInfo.instance.isConnected;
    if (isConnected) {
      await remoteDataSource.uploadProductImages(
        productId: productId,
        imageFiles: imageFiles,
      );
    } else {
      throw Exception('Không có mạng để upload hình');
    }
  }
}
