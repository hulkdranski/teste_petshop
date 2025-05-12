import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class LocationService {

  Future<List<Marker>> fetchNearbyPetshops(
      double latitude, double longitude) async {
    final url = Uri.parse("https://2eb9-186-231-48-157.ngrok-free.app/petshops-proximos");

    try {
      final response = await http.get(url, headers: {
      "ngrok-skip-browser-warning": "true",
    });

      if (response.statusCode == 200) {
        final List<dynamic> petshops = json.decode(response.body);

        return petshops.map((petshop) {
          return Marker(
            markerId: MarkerId(petshop['id'].toString()),
            position: LatLng(petshop['latitude'], petshop['longitude']),
            infoWindow: InfoWindow(title: petshop['nome']),
          );
        }).toList();
      } else {
        throw Exception("Erro ao buscar petshops: ${response.body}");
      }
    } catch (e) {
      throw Exception("Erro de conexão: $e");
    }
  }


  Future<List<Marker>> fetchPetshopsByPlaceIds(List<String> placeIds) async {
    List<Marker> markers = [];

    for (String placeId in placeIds) {
      final url = Uri.parse("https://2eb9-186-231-48-157.ngrok-free.app/petshop?placeId=$placeId");
      final response = await http.get(url, headers: {
      "ngrok-skip-browser-warning": "true",
    });

      if (response.statusCode == 200) {
        final petshop = json.decode(response.body);

        markers.add(
          Marker(
            markerId: MarkerId(petshop['id']),
            position: LatLng(petshop['latitude'], petshop['longitude']),
            infoWindow: InfoWindow(
              title: petshop['nome'],
              onTap: () {
                launchUrl(Uri.parse(petshop['mapsUrl']));
              },
            ),
          ),
        );
      }
    }

    return markers;
}

}
