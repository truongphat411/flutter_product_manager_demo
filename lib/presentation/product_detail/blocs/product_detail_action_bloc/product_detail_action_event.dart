import 'package:equatable/equatable.dart';

import '../../../../data/models/models.dart';

abstract class ProductDetailActionEvent extends Equatable {
  const ProductDetailActionEvent();

  @override
  List<Object?> get props => [];
}

class AddProduct extends ProductDetailActionEvent {
  final ProductModel product;
  const AddProduct(this.product);
}

class UpdateProduct extends ProductDetailActionEvent {
  final ProductModel product;
  const UpdateProduct(this.product);
}

class DeleteProduct extends ProductDetailActionEvent {
  final int productID;
  const DeleteProduct(this.productID);
}
