import '../../../data/models/models.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> fetchCategories();
}
