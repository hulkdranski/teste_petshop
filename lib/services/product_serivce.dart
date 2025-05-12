import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ProductService {
  final String baseUrl = 'https://2eb9-186-231-48-157.ngrok-free.app';

  Future<bool> createProduct(Map<String, dynamic> produto) async {
    final url = Uri.parse('$baseUrl/product/create');

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final payload = {
      ...produto,
      'firebaseuid': user.uid,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    return response.statusCode == 201;
  }

  Future<List<dynamic>> findAll() async {
    final url = Uri.parse('$baseUrl/product');
    final response = await http.get(url, 
    headers: {
      "ngrok-skip-browser-warning": "true",
    }
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar produtos');
    }
  }

  Future<List<dynamic>> getProductsByUser(String firebaseUid) async {
    final response = await http.get(
      Uri.parse('$baseUrl/product/get-products/$firebaseUid'),
      headers: {
      "ngrok-skip-browser-warning": "true",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar produtos');
    }
  }
}
