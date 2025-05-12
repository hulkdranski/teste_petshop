import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class StoreService {
  final String baseUrl = "https://2eb9-186-231-48-157.ngrok-free.app";

  Future<bool> createStore(String placeid, String cnpj) async {
    final url = Uri.parse('$baseUrl/store/create');

    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return false;
    }

    final userId = user.uid;

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'placeid': placeid,
        'cnpj': cnpj,
        'firebaseuid': userId,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<String>> getStore() async {
    final url = Uri.parse('$baseUrl/store/get-data');

    final response = await http.get(
      url,
      headers: {
      "ngrok-skip-browser-warning": "true",
    }
    );

    print('store' + response.body);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.cast<String>();
    } else {
      throw Exception("Erro ao buscar placeIds das lojas");
    }
    
  }
}
