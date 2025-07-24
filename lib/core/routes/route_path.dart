class RouterPath {
  RouterPath._();
  static const productList = '/product-list';
  static const productDetail = '/product-detail';
  static const productForm = '/product-form';
}

enum AppRouter {
  productList,
  productDetail,
  productForm,
}

extension AppRouterX on AppRouter {
  String get path {
    return switch (this) {
      AppRouter.productList => RouterPath.productList,
      AppRouter.productDetail => RouterPath.productDetail,
      AppRouter.productForm => RouterPath.productForm,
    };
  }
}
