import 'package:flutter_product_manager_demo/data/models/models.dart';

import '../../../core/services/network/network_info.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/local/local.dart';
import '../../datasources/remote/remote.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    final isConnected = await NetworkInfo.instance.isConnected;
    if (isConnected) {
      try {
        final remoteProducts = await remoteDataSource.fetchCategories();
        await localDataSource.cacheCategories(remoteProducts);
        return remoteProducts;
      } catch (_) {
        return await localDataSource.getCachedCategories();
      }
    } else {
      return await localDataSource.getCachedCategories();
    }
  }
}
