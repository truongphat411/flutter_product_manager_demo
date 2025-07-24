import 'package:flutter_product_manager_demo/presentation/product_list/blocs/category_list_bloc/category_list_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/services/database_service/database_service.dart';
import 'data/datasources/datasources.dart';
import 'data/repositories_impl/repositories_impl.dart';
import 'domain/repositories/repositories.dart';
import 'domain/usecases/usecases.dart';
import 'presentation/product_detail/blocs/product_detail_action_bloc/product_detail_action_bloc.dart';
import 'presentation/product_detail/blocs/product_detail_bloc/product_detail_bloc.dart';
import 'presentation/product_list/blocs/product_list_bloc/product_list_bloc.dart';

final getIt = GetIt.instance;

void init() {
  /// Blocs
  getIt.registerFactory(() => ProductListBloc(
        productUseCase: getIt<ProductUseCase>(),
      ));
  getIt.registerFactory(() => CategoryListBloc(
        categoryUseCase: getIt<CategoryUseCase>(),
      ));
  getIt.registerFactory(() => ProductDetailBloc(
        productUseCase: getIt<ProductUseCase>(),
      ));
  getIt.registerFactory(() => ProductDetailActionBloc(
        productUseCase: getIt<ProductUseCase>(),
      ));

  /// UseCases
  getIt.registerLazySingleton(
      () => ProductUseCase(repository: getIt<ProductRepository>()));
  getIt.registerLazySingleton(
      () => CategoryUseCase(repository: getIt<CategoryRepository>()));

  /// Repositories
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(
        remoteDataSource: getIt<ProductRemoteDataSource>(),
        localDataSource: getIt<ProductLocalDataSource>(),
      ));
  getIt.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(
        remoteDataSource: getIt<CategoryRemoteDataSource>(),
        localDataSource: getIt<CategoryLocalDataSource>(),
      ));

  /// RemoteDataSources
  getIt.registerLazySingleton(() => ProductRemoteDataSource());
  getIt.registerLazySingleton(() => CategoryRemoteDataSource());

  /// LocalDataSources
  getIt.registerLazySingleton(() => ProductLocalDataSource(
        databaseService: getIt<DatabaseService>(),
      ));
  getIt.registerLazySingleton(() => CategoryLocalDataSource(
        databaseService: getIt<DatabaseService>(),
      ));

  /// Services
  getIt.registerSingleton<DatabaseService>(DatabaseService());
}
