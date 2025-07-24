import '../../../data/models/models.dart';
import '../../repositories/repositories.dart';

class CategoryUseCase {
  final CategoryRepository repository;

  CategoryUseCase({
    required this.repository,
  });

  Future<List<CategoryModel>> fetchCategories() async {
    return await repository.fetchCategories();
  }
}
