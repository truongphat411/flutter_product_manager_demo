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
      throw Exception('Failed to cache categories: $e');
    }
  }

  Future<List<CategoryModel>> getCachedCategories() async {
    try {
      return await databaseService.getCachedCategories();
    } catch (e) {
      throw Exception('Failed to fetch cached categories: $e');
    }
  }
}
