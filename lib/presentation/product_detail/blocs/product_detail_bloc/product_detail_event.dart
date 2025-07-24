import 'package:equatable/equatable.dart';


abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class GetProductById extends ProductDetailEvent {
  final int productID;
  const GetProductById({
    required this.productID,
  });
}
