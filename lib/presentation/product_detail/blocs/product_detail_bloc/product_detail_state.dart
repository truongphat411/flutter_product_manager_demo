import 'package:equatable/equatable.dart';

import '../../../../data/models/models.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductModel product;
  const ProductDetailLoaded({
    required this.product,
  });
}

class ProductDetailSuccess extends ProductDetailState {
  final String message;
  const ProductDetailSuccess({
    required this.message,
  });
}

class ProductDetailError extends ProductDetailState {
  final String message;
  const ProductDetailError({
    required this.message,
  });
}
