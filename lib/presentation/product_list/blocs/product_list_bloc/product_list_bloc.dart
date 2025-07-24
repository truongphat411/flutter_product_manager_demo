import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/usecases.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductUseCase productUseCase;

  ProductListBloc({
    required this.productUseCase,
  }) : super(ProductListInitial()) {
    on<FetchProducts>(
      (event, emit) async {
        emit(ProductListLoading());
        try {
          final results = await productUseCase.fetchProducts(
            categoryId: event.categoryId,
            keyword: event.keyword,
          );

          emit(ProductListLoaded(
            products: results,
          ));
        } catch (e) {
          emit(ProductListError(message: e.toString()));
        }
      },
    );
  }
}
