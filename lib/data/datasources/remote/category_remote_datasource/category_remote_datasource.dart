import 'dart:convert';
import 'package:flutter_product_manager_demo/config/mock_data/mock_data.dart';
import 'package:http/http.dart' as http;

import '../../../models/models.dart';

class CategoryRemoteDataSource {
  CategoryRemoteDataSource({
    this.isMock = true,
  });
  final bool isMock;
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      if (isMock) {
        await Future.delayed(const Duration(milliseconds: 300));
        List<CategoryModel> categories = MockCategoryData.getAll();

        return categories;
      } else {
        //GET /categories → danh mục sản phẩm

        final uri = Uri.https('mock.api.com', '/categories');

        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data is List) {
            return data.map((item) => CategoryModel.fromJson(item)).toList();
          } else {
            throw Exception('Dữ liệu không hợp lệ');
          }
        } else {
          throw Exception('Lỗi server: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Không tải được danh mục: $e');
    }
  }
}
