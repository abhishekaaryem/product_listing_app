import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_listing_app/features/home/models/product_models.dart';

class HomeRepository {
  final String baseUrl = 'https://skilltestflutter.zybotechlab.com/api';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<BannerModel>> fetchBanners() async {
    final response = await http.get(Uri.parse('$baseUrl/banners/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => BannerModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load banners');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await http.post(
      Uri.parse('$baseUrl/search/?query=$query'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }
}
