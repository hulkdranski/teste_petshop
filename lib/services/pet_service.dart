import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class PetService {
  final String baseUrl = "https://2eb9-186-231-48-157.ngrok-free.app";

  Future<bool> createPet(
      String name, String raca, String idade, String sexo, String obs) async {
    final url = Uri.parse('$baseUrl/pets/create');
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
        'name': name,
        'raca': raca,
        'idade': idade,
        'sexo': sexo,
        'obs': obs,
        'firebaseuid': userId,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<dynamic>?> getPetData(String firebaseuid) async {
    final url = Uri.parse('$baseUrl/pets/get-data');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'firebaseuid': firebaseuid}),
    );
    if (response.statusCode == 201) {
      final decodedResponse = json.decode(response.body);

      if (decodedResponse is List) {
        return decodedResponse;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
