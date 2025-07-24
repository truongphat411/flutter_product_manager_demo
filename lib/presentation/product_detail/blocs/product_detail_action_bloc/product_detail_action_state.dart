import 'package:equatable/equatable.dart';

abstract class ProductDetailActionState extends Equatable {
  const ProductDetailActionState();

  @override
  List<Object?> get props => [];
}

class ProductDetailActionInitial extends ProductDetailActionState {}

class ProductDetailActionLoading extends ProductDetailActionState {}

class ProductDetailActionSuccess extends ProductDetailActionState {
  final String message;
  const ProductDetailActionSuccess({
    required this.message,
  });
}

class ProductDetailActionError extends ProductDetailActionState {
  final String message;
  const ProductDetailActionError({
    required this.message,
  });
}
