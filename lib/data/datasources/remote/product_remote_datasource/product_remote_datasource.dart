import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../config/mock_data/mock_data.dart';
import '../../../models/models.dart';

class ProductRemoteDataSource {
  ProductRemoteDataSource({
    this.isMock = true,
  });
  final bool isMock;
  Future<List<ProductModel>> fetchProducts({
    String? keyword,
    int? categoryId,
  }) async {
    try {
      if (isMock) {
        await Future.delayed(const Duration(milliseconds: 300));
        List<ProductModel> products = MockProductData.getAll();

        if (keyword != null && keyword.isNotEmpty) {
          products = products
              .where(
                  (p) => p.name.toLowerCase().contains(keyword.toLowerCase()))
              .toList();
        }

        if (categoryId != null) {
          products = products.where((p) => p.categoryId == categoryId).toList();
        }

        return products;
      } else {
        //GET /products → danh sách sản phẩm, hỗ trợ ?q=keyword, ?categoryId=
        final queryParams = <String, String>{};
        if (keyword != null && keyword.isNotEmpty) {
          queryParams['q'] = keyword;
        }
        if (categoryId != null) {
          queryParams['categoryId'] = categoryId.toString();
        }

        final uri = Uri.https('mock.api.com', '/products', queryParams);

        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data is List) {
            return data.map((item) => ProductModel.fromJson(item)).toList();
          } else {
            throw Exception('Dữ liệu không hợp lệ');
          }
        } else {
          throw Exception('Lỗi server: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Không tải được sản phẩm: $e');
    }
  }

  Future<ProductModel> getProductByID({
    required int productId,
  }) async {
    try {
      if (isMock) {
        await Future.delayed(const Duration(milliseconds: 300));
        final product = MockProductData.getById(productId);
        return product;
      } else {
        //GET /products/{id} → chi tiết sản phẩm
        final uri = Uri.https('mock.api.com', '/products/$productId');
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return ProductModel.fromJson(data);
        } else {
          throw Exception('Lỗi server: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Không tải được sản phẩm: $e');
    }
  }

  Future<void> createProduct({
    required ProductModel product,
  }) async {
    try {
      if (isMock) {
        await Future.delayed(const Duration(milliseconds: 300));
        MockProductData.add(product);
      } else {
        //POST /products → tạo mới sản phẩm (body: JSON)
        final uri = Uri.https('mock.api.com', '/products');
        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(product.toJson()),
        );

        if (response.statusCode != 201) {
          throw Exception('Tạo sản phẩm thất bại: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Không tải được sản phẩm: $e');
    }
  }

  Future<void> updateProduct({
    required ProductModel product,
  }) async {
    try {
      if (isMock) {
        await Future.delayed(const Duration(milliseconds: 300));
        MockProductData.update(product);
      } else {
        //PUT /products/{id} → cập nhật thông tin sản phẩm
        final uri = Uri.https('mock.api.com', '/products/${product.id}');
        final response = await http.put(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(product.toJson()),
        );

        if (response.statusCode != 200) {
          throw Exception('Cập nhật sản phẩm thất bại: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Không tải được sản phẩm: $e');
    }
  }

  Future<void> deleteProduct({
    required int productId,
  }) async {
    try {
      if (isMock) {
        await Future.delayed(const Duration(milliseconds: 300));
        MockProductData.delete(productId);
      } else {
        //DELETE /products/{id} → xóa sản phẩm
        final uri = Uri.https('mock.api.com', '/products/$productId');
        final response = await http.delete(uri);

        if (response.statusCode != 200 && response.statusCode != 204) {
          throw Exception('Xoá sản phẩm thất bại: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Không tải được sản phẩm: $e');
    }
  }

  Future<void> uploadProductImages({
    required int productId,
    required List<File> imageFiles,
  }) async {
    //POST /products/{id}/images → upload hình (multipart)
  }
}
