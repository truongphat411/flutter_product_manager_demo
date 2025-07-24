import '../../../../core/services/database_service/database_service.dart';
import '../../../models/models.dart';

class ProductLocalDataSource {
  final DatabaseService databaseService;

  ProductLocalDataSource({
    required this.databaseService,
  });

  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      await databaseService.cacheProduct(products);
    } catch (e) {
      throw Exception('Không lưu được sản phẩm vào bộ nhớ đệm: $e');
    }
  }

  Future<List<ProductModel>> getCachedProducts({
    String? keyword,
    int? categoryId,
  }) async {
    try {
      return await databaseService.getCachedProduct(
          keyword: keyword, categoryId: categoryId);
    } catch (e) {
      throw Exception('Không thể tải các sản phẩm được lưu trong bộ nhớ đệm: $e');
    }
  }

  Future<ProductModel> getProductByID(int id) async {
    try {
      return await databaseService.getProductByID(id);
    } catch (e) {
      throw Exception('Không tìm được sản phẩm theo ID: $e');
    }
  }
}
