import 'package:equatable/equatable.dart';

import '../../../../data/models/models.dart';

abstract class CategoryListState extends Equatable {
  const CategoryListState();

  @override
  List<Object?> get props => [];
}

class CategoryListInitial extends CategoryListState {}

class CategoryListLoading extends CategoryListState {}

class CategoryListLoaded extends CategoryListState {
  final List<CategoryModel> categories;
  const CategoryListLoaded({
    required this.categories,
  });
}

class CategoryListError extends CategoryListState {
  final String message;
  const CategoryListError({
    required this.message,
  });
}
