import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_product_manager_demo/presentation/components/common_app_bar.dart';
import 'package:flutter_product_manager_demo/presentation/components/image_widget.dart';
import 'package:flutter_product_manager_demo/presentation/components/loading_overlay_controller.dart';
import 'package:flutter_product_manager_demo/presentation/components/text_field_base.dart';
import 'package:flutter_product_manager_demo/presentation/product_detail/blocs/product_detail_bloc/product_detail_event.dart';
import 'package:flutter_product_manager_demo/presentation/product_list/blocs/category_list_bloc/category_list_bloc.dart';
import 'package:flutter_product_manager_demo/presentation/product_list/blocs/category_list_bloc/category_list_state.dart';
import 'package:flutter_product_manager_demo/presentation/product_list/blocs/product_list_bloc/product_list_event.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/models.dart';
import '../components/common_dialog.dart';
import '../product_detail/blocs/product_detail_action_bloc/product_detail_action_bloc.dart';
import '../product_detail/blocs/product_detail_action_bloc/product_detail_action_event.dart';
import '../product_detail/blocs/product_detail_action_bloc/product_detail_action_state.dart';
import '../product_detail/blocs/product_detail_bloc/product_detail_bloc.dart';
import '../product_list/blocs/product_list_bloc/product_list_bloc.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductModel? product;

  const ProductFormScreen({
    super.key,
    this.product,
  });

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  int? _categoryId;
  List<String> _imagePaths = [];
  final ImagePicker _picker = ImagePicker();
  Timer? _debounceTimer;
  ProductDetailActionBloc get _productDetailActionBloc =>
      context.read<ProductDetailActionBloc>();
  ProductDetailBloc get _productDetailBloc => context.read<ProductDetailBloc>();
  ProductListBloc get _productListBloc => context.read<ProductListBloc>();

  static const int maxImages = 5;
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxStock = 10000;
  static const int priceMultiple = 1000;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stockQuantity.toString();
      _categoryId = widget.product!.categoryId;
      _imagePaths = List.from(widget.product!.images);
    }
  }

  Future<void> _pickImagesFromGallery() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isEmpty) return;
      final newImages = pickedFiles.map((file) => file.path).toList();
      if (_imagePaths.length + newImages.length > maxImages) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tối đa $maxImages hình ảnh')),
        );
        return;
      }
      setState(() {
        _imagePaths.addAll(newImages);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chọn hình ảnh: $e')),
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) return;
      if (_imagePaths.length >= maxImages) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tối đa $maxImages hình ảnh')),
        );
        return;
      }
      setState(() {
        _imagePaths.add(pickedFile.path);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chụp ảnh: $e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newProduct = ProductModel(
        id: widget.product?.id ?? 0,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: int.parse(_priceController.text),
        stockQuantity: int.parse(_stockController.text),
        categoryId: _categoryId!,
        images: _imagePaths,
      );
      if (widget.product == null) {
        _productDetailActionBloc.add(AddProduct(newProduct));
      } else {
        _productDetailActionBloc.add(UpdateProduct(newProduct));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductDetailActionBloc, ProductDetailActionState>(
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
          if (widget.product != null) {
            _productDetailBloc
                .add(GetProductById(productID: widget.product!.id));
          }
          _productListBloc.add(const FetchProducts());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.of(context).pop();
        }
        LoadingOverlayController.instance.hide();
      },
      child: Scaffold(
        appBar: CommonAppBar(
          title: Text(
            widget.product == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm',
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: _saveForm,
              child: Text(
                widget.product == null ? 'Thêm' : 'Lưu',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldBase(
                    controller: _nameController,
                    hintText: 'Tên sản phẩm',
                    maxLength: maxNameLength,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Tên sản phẩm là bắt buộc';
                      }
                      return null;
                    },
                  ),
                  TextFieldBase(
                    controller: _descriptionController,
                    hintText: 'Mô tả',
                    maxLength: maxDescriptionLength,
                    maxLines: 3,
                    minLines: 1,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Mô tả là bắt buộc';
                      }
                      return null;
                    },
                  ),
                  TextFieldBase(
                    controller: _priceController,
                    hintText: 'Giá',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Giá là bắt buộc';
                      }
                      final price = int.tryParse(value);
                      if (price == null || price <= 0) {
                        return 'Giá phải là số dương';
                      }
                      if (price % priceMultiple != 0) {
                        return 'Giá phải là bội số của $priceMultiple';
                      }
                      return null;
                    },
                  ),
                  TextFieldBase(
                    controller: _stockController,
                    hintText: 'Tồn kho',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Tồn kho là bắt buộc';
                      }
                      final stock = int.tryParse(value);
                      if (stock == null || stock < 0 || stock > maxStock) {
                        return 'Tồn kho phải từ 0 đến $maxStock';
                      }
                      return null;
                    },
                  ),
                  BlocBuilder<CategoryListBloc, CategoryListState>(
                    builder: (context, state) {
                      List<CategoryModel> categories = [];
                      if (state is CategoryListLoaded) {
                        categories = state.categories;
                      }
                      return DropdownButtonFormField<int>(
                        value: _categoryId,
                        decoration: const InputDecoration(
                          hintText: 'Danh mục',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        items: categories
                            .map((category) => DropdownMenuItem(
                                  value: category.id,
                                  child: Text(category.name),
                                ))
                            .toList(),
                        validator: (value) =>
                            value == null ? 'Danh mục là bắt buộc' : null,
                        onChanged: (value) => setState(() {
                          _categoryId = value;
                        }),
                        onSaved: (value) => _categoryId = value,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hình ảnh (${_imagePaths.length}/$maxImages)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImagesFromGallery,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Thư viện'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _pickImageFromCamera,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Máy ảnh'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _imagePaths.asMap().entries.map((entry) {
                      final index = entry.key;
                      final path = entry.value;
                      return Stack(
                        children: [
                          ImageWidget(
                            url: path,
                            width: 100,
                            height: 100,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                color: Colors.black54,
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
