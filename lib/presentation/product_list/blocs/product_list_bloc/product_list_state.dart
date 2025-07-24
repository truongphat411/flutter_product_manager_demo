import 'package:equatable/equatable.dart';

import '../../../../data/models/models.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<ProductModel> products;
  const ProductListLoaded({
    required this.products,
  });
}

class ProductListError extends ProductListState {
  final String message;
  const ProductListError({
    required this.message,
  });
}
