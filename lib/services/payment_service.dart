import 'dart:convert';

import 'package:http/http.dart' as http;

class PaymentService {
  // Android emulator:
  static const String baseUrl = 'http://10.0.2.2:5000';

  // If you use a physical phone, this will need to be your Mac's
  // local IP address instead.

  Future<Map<String, dynamic>> initializePayment({
    required String email,
    required double amount,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/initialize-payment'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'amount': amount,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ?? 'Payment initialization failed',
      );
    }

    if (data['success'] != true) {
      throw Exception(
        data['message'] ?? 'Payment initialization failed',
      );
    }

    return data;
  }

  Future<Map<String, dynamic>> verifyPayment(
    String reference,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/verify-payment/$reference',
      ),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ?? 'Payment verification failed',
      );
    }

    if (data['success'] != true) {
      throw Exception(
        data['message'] ?? 'Payment verification failed',
      );
    }

    return data;
  }
}