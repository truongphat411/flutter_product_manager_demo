import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_product_manager_demo/core/extension/num_extension.dart';
import 'package:flutter_product_manager_demo/presentation/components/common_app_bar.dart';
import 'package:flutter_product_manager_demo/presentation/components/image_widget.dart';
import 'package:flutter_product_manager_demo/presentation/components/loading_overlay_controller.dart';
import 'package:flutter_product_manager_demo/presentation/product_list/blocs/category_list_bloc/category_list_bloc.dart';
import 'package:flutter_product_manager_demo/presentation/product_list/blocs/category_list_bloc/category_list_event.dart';
import 'package:flutter_product_manager_demo/presentation/product_list/blocs/category_list_bloc/category_list_state.dart';
import 'package:flutter_product_manager_demo/presentation/product_list/blocs/product_list_bloc/product_list_bloc.dart';
import 'package:flutter_product_manager_demo/presentation/product_list/blocs/product_list_bloc/product_list_event.dart';
import 'package:flutter_product_manager_demo/presentation/product_list/blocs/product_list_bloc/product_list_state.dart';
import 'package:go_router/go_router.dart';
import '../../core/core.dart';
import '../../data/models/models.dart';
import '../components/search_bar_base.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  FocusNode node = FocusNode();
  int? _selectedCategoryId;
  Timer? _debounceTimer;
  ProductListBloc get _productListBloc => context.read<ProductListBloc>();
  CategoryListBloc get _categoryListBloc => context.read<CategoryListBloc>();

  @override
  void initState() {
    super.initState();
    _productListBloc.add(const FetchProducts());
    _categoryListBloc.add(const FetchCategories());
  }

  void _onSearchChanged({
    String? keyword,
  }) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      context.read<ProductListBloc>().add(FetchProducts(
            keyword: keyword,
            categoryId: _selectedCategoryId,
          ));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductListBloc, ProductListState>(
      listener: (context, state) {
        if (state is ProductListLoading) {
          LoadingOverlayController.instance.show(context);
        }
        LoadingOverlayController.instance.hide();
      },
      child: GestureDetector(
        onTap: () => node.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          appBar: CommonAppBar(
            title: const Text(
              'Danh sách sản phẩm',
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              BlocBuilder<CategoryListBloc, CategoryListState>(
                builder: (context, state) {
                  List<CategoryModel> categories = [];
                  if (state is CategoryListLoaded) {
                    categories = state.categories;
                  }
                  return PopupMenuButton<int>(
                    initialValue: _selectedCategoryId,
                    onSelected: (value) {
                      node.unfocus();
                      setState(() {
                        _selectedCategoryId = value == 0 ? null : value;
                      });
                      context.read<ProductListBloc>().add(FetchProducts(
                            keyword: _searchController.text,
                            categoryId: _selectedCategoryId,
                          ));
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Text('Tất cả'),
                      ),
                      ...categories.map((category) => PopupMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          )),
                    ],
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              SearchBarBase(
                controller: _searchController,
                node: node,
                onChanged: (value) {
                  _onSearchChanged(keyword: value);
                },
              ),
              Expanded(
                child: BlocBuilder<ProductListBloc, ProductListState>(
                  builder: (context, state) {
                    if (state is ProductListError) {
                      return Center(
                        child: Text(state.message),
                      );
                    }
                    if (state is ProductListLoaded && state.products.isEmpty) {
                      return const Center(
                        child: Text('Không có bất kì sản phẩm nào'),
                      );
                    }
                    if (state is ProductListLoaded) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<ProductListBloc>().add(FetchProducts(
                                keyword: _searchController.text,
                                categoryId: _selectedCategoryId,
                              ));
                        },
                        child: ListView.builder(
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return ListTile(
                              leading: product.images.isNotEmpty
                                  ? ImageWidget(
                                      url: product.images[0],
                                      width: 50,
                                      height: 50,
                                    )
                                  : const Icon(Icons.broken_image),
                              title: Text(product.name),
                              subtitle: Text(
                                  'Giá: ${product.price.toVND()} | Tồn kho: ${product.stockQuantity}'),
                              onTap: () {
                                node.unfocus();
                                context.push(
                                  '${RouterPath.productList}${RouterPath.productDetail}?productID=${product.id}',
                                );
                              },
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.push(
                '${RouterPath.productList}${RouterPath.productForm}',
                extra: null,
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
