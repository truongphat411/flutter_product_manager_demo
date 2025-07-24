import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_product_manager_demo/service_locator.dart';
import 'core/routes/router.dart';
import 'presentation/product_detail/blocs/product_detail_action_bloc/product_detail_action_bloc.dart';
import 'presentation/product_detail/blocs/product_detail_bloc/product_detail_bloc.dart';
import 'presentation/product_list/blocs/category_list_bloc/category_list_bloc.dart';
import 'presentation/product_list/blocs/product_list_bloc/product_list_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ProductListBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<CategoryListBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<ProductDetailBloc>(),
        ),
        // BlocProvider(
        //   create: (_) => getIt<ProductDetailActionBloc>(),
        // ),
      ],
      child: MaterialApp.router(
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
