import '../../data/models/models.dart';

class MockCategoryData {
  static final List<CategoryModel> _categories = [
    CategoryModel(id: 1, name: 'Quần áo nam'),
    CategoryModel(id: 2, name: 'Quần áo nữ'),
    CategoryModel(id: 3, name: 'Trang sức'),
    CategoryModel(id: 4, name: 'Thiết bị điện tử'),
  ];

  static List<CategoryModel> getAll() => List.unmodifiable(_categories);
}
