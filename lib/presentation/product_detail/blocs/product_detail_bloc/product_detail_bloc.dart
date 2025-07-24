import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/usecases.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductUseCase productUseCase;

  ProductDetailBloc({required this.productUseCase})
      : super(ProductDetailInitial()) {
    on<GetProductById>(
      (event, emit) async {
        emit(ProductDetailLoading());
        try {
          final result =
              await productUseCase.getProductById(productId: event.productID);

          emit(ProductDetailLoaded(
            product: result,
          ));
        } catch (e) {
          emit(ProductDetailError(message: e.toString()));
        }
      },
    );
  }
}
