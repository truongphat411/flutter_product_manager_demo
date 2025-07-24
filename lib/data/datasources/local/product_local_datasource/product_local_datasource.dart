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
      throw Exception('Failed to cache products: $e');
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
      throw Exception('Failed to fetch cached products: $e');
    }
  }

  Future<ProductModel> getProductByID(int id) async {
    try {
      return await databaseService.getProductByID(id);
    } catch (e) {
      throw Exception('Failed to fetch product by ID: $e');
    }
  }
}
