import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductListEvent {
  final String? keyword;
  final int? categoryId;
  const FetchProducts({
    this.keyword,
    this.categoryId,
  });
}
