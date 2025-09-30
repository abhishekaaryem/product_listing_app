import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_listing_app/features/home/models/product_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistRepository {
  final String baseUrl = 'https://skilltestflutter.zybotechlab.com/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<List<Product>> fetchWishlist() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/wishlist/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Ensure wishlist items are flagged as favorite in the app model
      final List<Product> products = data
          .map((json) => Product.fromJson(json).copyWith(isFavorite: true))
          .toList();
      return products;
    } else {
      throw Exception('Failed to load wishlist');
    }
  }

  Future<void> addOrRemoveWishlist(String productId) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/add-remove-wishlist/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'product_id': int.parse(productId)}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update wishlist');
    }
  }
}
