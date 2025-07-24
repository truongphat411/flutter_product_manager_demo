import '../../../../core/services/database_service/database_service.dart';
import '../../../models/models.dart';

class CategoryLocalDataSource {
  final DatabaseService databaseService;

  CategoryLocalDataSource({
    required this.databaseService,
  });

  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      await databaseService.cacheCategories(categories);
    } catch (e) {
      throw Exception('Không lưu được danh mục vào bộ nhớ đệm: $e');
    }
  }

  Future<List<CategoryModel>> getCachedCategories() async {
    try {
      return await databaseService.getCachedCategories();
    } catch (e) {
      throw Exception('Không thể tải các danh mục được lưu trong bộ nhớ đệm: $e');
    }
  }
}
