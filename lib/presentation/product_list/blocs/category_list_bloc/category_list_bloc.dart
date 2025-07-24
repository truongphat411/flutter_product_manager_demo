import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/usecases.dart';
import 'category_list_event.dart';
import 'category_list_state.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  final CategoryUseCase categoryUseCase;

  CategoryListBloc({
    required this.categoryUseCase,
  }) : super(CategoryListInitial()) {
    on<FetchCategories>(
      (event, emit) async {
        emit(CategoryListLoading());
        try {
          final results = await categoryUseCase.fetchCategories();

          emit(CategoryListLoaded(
            categories: results,
          ));
        } catch (e) {
          emit(CategoryListError(message: e.toString()));
        }
      },
    );
  }
}
