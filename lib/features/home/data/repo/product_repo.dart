import 'package:hungry_app/core/network/api_service.dart';
import 'package:hungry_app/features/home/data/models/category_model.dart';
import 'package:hungry_app/features/home/data/models/product_model.dart';
import 'package:hungry_app/features/home/data/models/topping_model.dart';

import '../models/data.dart';

class ProductRepo {
  final ApiService _apiService = ApiService();

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiService.get('products/');
      return (response['data'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<ToppingModel>> getToppings() async {
    try {
      final response = await _apiService.get('toppings');
      return (response['data'] as List)
          .map((topping) => ToppingModel.fromJson(topping))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<ToppingModel>> getOptions() async {
    try {
      final response = await _apiService.get('side-options');
      return (response['data'] as List)
          .map((topping) => ToppingModel.fromJson(topping))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> searchField(String name) async {
    try {
      final response = await _apiService.get('products', param: {'name': name});
      return (response['data'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<Data>> getCategories() async {
    try {
      final response = await _apiService.get('categories');
      final categoryModel = CategoryModel.fromJson(response);
      return categoryModel.data ?? [];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getProductsByCategory({
    int? categoryId,
    String? name,
  }) async {
    try {
      final Map<String, dynamic> query = {};

      if (categoryId != null) {
        query['category_id'] = categoryId;
      }

      if (name != null && name.isNotEmpty) {
        query['name'] = name;
      }

      final response = await _apiService.get('products', param: query);

      return (response['data'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
