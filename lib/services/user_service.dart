import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final String baseUrl = "https://2eb9-186-231-48-157.ngrok-free.app";

  Future<bool> createProfile(
      String firebaseuid, String name, String cpf, String address) async {
    final url = Uri.parse('$baseUrl/users/create');

    final firebaseToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    if (firebaseToken == null) {
      return false;
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $firebaseToken',
      },
      body: json.encode({
        'firebaseuid': firebaseuid,
        'name': name,
        'cpf': cpf,
        'address': address,
      }),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getProfileData(String firebaseuid) async {
    final url = Uri.parse('$baseUrl/users/get-user');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'firebaseuid': firebaseuid}),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  Future<bool> isRegistered(String firebaseuid) async {
    final url = Uri.parse('$baseUrl/users/get-user');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'firebaseuid': firebaseuid}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
