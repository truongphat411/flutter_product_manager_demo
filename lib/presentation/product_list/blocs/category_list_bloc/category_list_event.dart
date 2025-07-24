import 'package:equatable/equatable.dart';

abstract class CategoryListEvent extends Equatable {
  const CategoryListEvent();

  @override
  List<Object?> get props => [];
}

class FetchCategories extends CategoryListEvent {
  const FetchCategories();
}
