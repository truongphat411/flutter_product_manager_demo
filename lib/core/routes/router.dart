import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_product_manager_demo/data/models/product_model/product_model.dart';
import 'package:flutter_product_manager_demo/presentation/product_detail/product_detail_screen.dart';
import 'package:flutter_product_manager_demo/presentation/product_form/product_form_screen.dart';
import 'package:flutter_product_manager_demo/presentation/product_list/product_list_screen.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/product_detail/blocs/product_detail_action_bloc/product_detail_action_bloc.dart';
import '../../service_locator.dart';
import 'route_path.dart';

final router = GoRouter(
  initialLocation: RouterPath.productList,
  routes: [
    GoRoute(
      path: RouterPath.productList,
      builder: (context, state) {
        return const ProductListScreen();
      },
      routes: [
        GoRoute(
          path: RouterPath.productDetail,
          builder: (context, state) {
            final productID = state.uri.queryParameters['productID'] ?? '0';
            return BlocProvider(
              create: (_) => getIt<ProductDetailActionBloc>(),
              child: ProductDetailsScreen(
                productID: int.parse(productID),
              ),
            );
          },
        ),
        GoRoute(
          path: RouterPath.productForm,
          builder: (context, state) {
            final $extra = state.extra as ProductModel?;
            return BlocProvider(
              create: (_) => getIt<ProductDetailActionBloc>(),
              child: ProductFormScreen(
                product: $extra,
              ),
            );
          },
        ),
      ],
    ),
  ],
);
