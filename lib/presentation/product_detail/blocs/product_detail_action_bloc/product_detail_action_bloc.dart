import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/usecases.dart';
import 'product_detail_action_event.dart';
import 'product_detail_action_state.dart';

class ProductDetailActionBloc
    extends Bloc<ProductDetailActionEvent, ProductDetailActionState> {
  final ProductUseCase productUseCase;

  ProductDetailActionBloc({
    required this.productUseCase,
  }) : super(ProductDetailActionInitial()) {
    on<AddProduct>(
      (event, emit) async {
        emit(ProductDetailActionLoading());
        try {
          await productUseCase.createProduct(product: event.product);

          emit(const ProductDetailActionSuccess(
            message: 'Thêm mới thành công',
          ));
        } catch (e) {
          emit(ProductDetailActionError(message: e.toString()));
        }
      },
    );
    on<UpdateProduct>(
      (event, emit) async {
        emit(ProductDetailActionLoading());
        try {
          await productUseCase.updateProduct(product: event.product);

          emit(const ProductDetailActionSuccess(
            message: 'Cập nhật thành công',
          ));
        } catch (e) {
          emit(ProductDetailActionError(message: e.toString()));
        }
      },
    );
    on<DeleteProduct>(
      (event, emit) async {
        emit(ProductDetailActionLoading());
        try {
          await productUseCase.deleteProduct(productId: event.productID);

          emit(const ProductDetailActionSuccess(
            message: 'Xóa thành công',
          ));
        } catch (e) {
          emit(ProductDetailActionError(message: e.toString()));
        }
      },
    );
  }
}
