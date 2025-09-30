import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_listing_app/core/utils/network_utils.dart';
import '../models/user_model.dart';

class AuthRepository {
  static const baseUrl = 'https://skilltestflutter.zybotechlab.com/api';

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    // Dummy function - return true to continue
    return true;
  }

  Future<UserModel> saveName(String name, String phoneNumber) async {
    // Check network connectivity
    await NetworkUtils.checkConnectivity();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login-register/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'phone_number': phoneNumber,
          'first_name': name,
        }),
      );

      log('Save Name Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userModel = UserModel(
          phoneNumber: phoneNumber,
          firstName: name,
          token: data['token']['access'],
        );

        // Save JWT token to SharedPreferences if available
        if (userModel.token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', userModel.token!);
          log('JWT token saved: ${userModel.token}'); // Debug print
        }

        return userModel;
      } else {
        throw Exception('Failed to save name: ${response.statusCode}');
      }
    } catch (e) {
      log('Save Name Error: $e');
      throw Exception('Failed to save name: $e');
    }
  }

  Future<Map<String, dynamic>> verifyPhone(String phoneNumber) async {
    // Check for 10 digits
    if (phoneNumber.length != 10) {
      return {'message': 'Invalid phone number'};
    }
    // Merge country code
    final fullPhoneNumber = '+91$phoneNumber';
    // Dummy function - return true to continue
    return {'message': 'Login Successful', 'fullPhoneNumber': fullPhoneNumber};
  }
}
