import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_product_manager_demo/core/extension/num_extension.dart';
import 'package:flutter_product_manager_demo/presentation/components/common_app_bar.dart';
import 'package:flutter_product_manager_demo/presentation/components/image_widget.dart';
import 'package:flutter_product_manager_demo/presentation/product_detail/blocs/product_detail_action_bloc/product_detail_action_event.dart';
import 'package:flutter_product_manager_demo/presentation/product_detail/blocs/product_detail_action_bloc/product_detail_action_state.dart';
import 'package:go_router/go_router.dart';

import '../../core/core.dart';
import '../components/common_dialog.dart';
import '../components/loading_overlay_controller.dart';
import '../product_list/blocs/product_list_bloc/product_list_bloc.dart';
import '../product_list/blocs/product_list_bloc/product_list_event.dart';
import 'blocs/product_detail_action_bloc/product_detail_action_bloc.dart';
import 'blocs/product_detail_bloc/product_detail_bloc.dart';
import 'blocs/product_detail_bloc/product_detail_event.dart';
import 'blocs/product_detail_bloc/product_detail_state.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    required this.productID,
    super.key,
  });

  final int productID;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductDetailBloc get _productDetailBloc => context.read<ProductDetailBloc>();

  @override
  void initState() {
    super.initState();
    _productDetailBloc.add(GetProductById(productID: widget.productID));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return BlocConsumer<ProductDetailBloc, ProductDetailState>(
  //     listener: (context, state) {
  //       if (state is ProductDetailLoading) {
  //         LoadingOverlayController.instance.show(context);
  //       } else if (state is ProductDetailError) {
  //         CommonDialog.instance.show(
  //           context: context,
  //           content: state.message,
  //           contentYes: 'Xác nhận',
  //           onYes: () {},
  //         );
  //       }
  //       LoadingOverlayController.instance.hide();
  //     },
  //     builder: (context, state) {
  //       return Scaffold(
  //         appBar: const CommonAppBar(
  //           title: Text(
  //             'Chi tiết sản phẩm',
  //             style: TextStyle(
  //               fontSize: 18,
  //             ),
  //           ),
  //         ),
  //         body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
  //           builder: (context, state) {
  //             if (state is ProductDetailError) {
  //               return Center(
  //                 child: Text(state.message),
  //               );
  //             }
  //             if (state is ProductDetailLoaded) {
  //               final product = state.product;
  //               return SingleChildScrollView(
  //                 child: Column(
  //                   children: [
  //                     if (product.images.isNotEmpty)
  //                       CarouselSlider(
  //                         options:
  //                             CarouselOptions(height: 200.0, autoPlay: true),
  //                         items: product.images.map((url) {
  //                           return ImageWidget(
  //                             url: url,
  //                           );
  //                         }).toList(),
  //                       )
  //                     else
  //                       const SizedBox(
  //                         height: 200.0,
  //                         child: Icon(Icons.broken_image, size: 100),
  //                       ),
  //                     const SizedBox(
  //                       height: 16,
  //                     ),
  //                     ListTile(
  //                       title: Text(
  //                         product.name,
  //                         style: const TextStyle(fontWeight: FontWeight.bold),
  //                       ),
  //                       subtitle: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(product.description),
  //                           const SizedBox(
  //                             height: 8,
  //                           ),
  //                           Text('Giá: ${product.price.toVND()}'),
  //                           const SizedBox(
  //                             height: 8,
  //                           ),
  //                           Text('Tồn Kho: ${product.stockQuantity}'),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }
  //             return const SizedBox.shrink();
  //           },
  //         ),
  //         floatingActionButton: const _FloatingActionButton(),
  //       );
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductDetailBloc, ProductDetailState>(
          listener: (context, state) {
            if (state is ProductDetailLoading) {
              LoadingOverlayController.instance.show(context);
            } else if (state is ProductDetailError) {
              CommonDialog.instance.show(
                context: context,
                content: state.message,
                contentYes: 'Xác nhận',
                onYes: () {},
              );
            }
            LoadingOverlayController.instance.hide();
          },
        ),
        BlocListener<ProductDetailActionBloc, ProductDetailActionState>(
          listener: (context, state) {
            if (state is ProductDetailActionLoading) {
              LoadingOverlayController.instance.show(context);
            } else if (state is ProductDetailActionError) {
              CommonDialog.instance.show(
                context: context,
                content: state.message,
                contentYes: 'Xác nhận',
                onYes: () {},
              );
            } else if (state is ProductDetailActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.of(context).pop();
            }
            LoadingOverlayController.instance.hide();
          },
        ),
      ],
      child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const CommonAppBar(
              title: Text(
                'Chi tiết sản phẩm',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
              builder: (context, state) {
                if (state is ProductDetailError) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                if (state is ProductDetailLoaded) {
                  final product = state.product;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        if (product.images.isNotEmpty)
                          CarouselSlider(
                            options:
                                CarouselOptions(height: 200.0, autoPlay: true),
                            items: product.images.map((url) {
                              return ImageWidget(
                                url: url,
                              );
                            }).toList(),
                          )
                        else
                          const SizedBox(
                            height: 200.0,
                            child: Icon(Icons.broken_image, size: 100),
                          ),
                        const SizedBox(
                          height: 16,
                        ),
                        ListTile(
                          title: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.description),
                              const SizedBox(
                                height: 8,
                              ),
                              Text('Giá: ${product.price.toVND()}'),
                              const SizedBox(
                                height: 8,
                              ),
                              Text('Tồn Kho: ${product.stockQuantity}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            floatingActionButton: const _FloatingActionButton(),
          );
        },
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton();

  @override
  Widget build(BuildContext context) {
    final productDetailActionBloc = context.read<ProductDetailActionBloc>();
    final productListBloc = context.read<ProductListBloc>();
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        if (state is! ProductDetailLoaded) {
          return const SizedBox.shrink();
        }
        final product = state.product;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'Sửa',
              onPressed: () {
                context.push(
                  '${RouterPath.productList}${RouterPath.productForm}',
                  extra: product,
                );
              },
              child: const Icon(Icons.edit),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'Xóa',
              onPressed: () async {
                CommonDialog.instance.show(
                  context: context,
                  content: 'Bạn chắc muốn xóa sản phẩm?',
                  contentYes: 'Xóa',
                  onYes: () {
                    productDetailActionBloc.add(DeleteProduct(product.id));
                    productListBloc.add(const FetchProducts());
                    // Navigator.of(context).pop();
                  },
                  contentNo: 'Hủy',
                );
              },
              child: const Icon(Icons.delete),
            ),
          ],
        );
      },
    );
  }
}
