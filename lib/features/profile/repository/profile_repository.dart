import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:product_listing_app/features/profile/models/profile_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_listing_app/core/utils/network_utils.dart';

class ProfileRepository {
  static const String baseUrl = 'https://skilltestflutter.zybotechlab.com/api';
  static const String userDataEndpoint = '/user-data/';

  Future<UserProfile> fetchUserProfile() async {
    try {
      // Check network connectivity first
      await NetworkUtils.checkConnectivity();

      final token = await getJwtToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      log('Fetching user profile with token: ${token.substring(0, 20)}...');

      final response = await NetworkUtils.retryWithExponentialBackoff(
        () async {
          return await http.get(
            Uri.parse('$baseUrl$userDataEndpoint'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );
        },
        maxRetries: 3,
        initialDelay: const Duration(seconds: 1),
      );

      log('Profile fetch response status: ${response.statusCode}');
      log('Profile fetch response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserProfile(
          id: 0, // No id in response
          name: data['name'],
          email: '', // No email in response
          phone: data['phone_number'],
        );
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed');
      } else if (response.statusCode == 404) {
        throw Exception('User profile not found');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception('Failed to fetch profile: ${response.body}');
      }
    } catch (e) {
      log('Profile Fetch Error: $e');

      // Handle specific error types with user-friendly messages
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        throw Exception(
            'Network error. Please check your internet connection and try again.');
      }

      if (e.toString().contains('No authentication token found')) {
        throw Exception('Authentication required. Please login again.');
      }

      if (e.toString().contains('Authentication failed')) {
        throw Exception('Session expired. Please login again.');
      }

      // Re-throw the exception with a user-friendly message
      throw Exception('Failed to load profile. Please try again.');
    }
  }

  // Helper method to save JWT token (can be used during login)
  Future<void> saveJwtToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  // Helper method to clear JWT token (for logout)
  Future<void> clearJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  // Helper method to get current JWT token
  Future<String?> getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
}
