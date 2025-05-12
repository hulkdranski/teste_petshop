import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:teste_petshop/screens/home_screen.dart';
import 'package:teste_petshop/services/location_service.dart';
import 'package:teste_petshop/services/store_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _userLocation = const LatLng(-23.55052, -46.633308);
  Set<Marker> _markers = {};
  bool _isLoading = true;
  final LocationService _locationService = LocationService();
  final StoreService _storeService = StoreService();

  @override
  void initState() {
    super.initState();
    _loadLocationAndPlaces();
  }

  Future<void> _loadLocationAndPlaces() async {
     try {
    Position position = await _getCurrentLocation();
    LatLng userLatLng = LatLng(position.latitude, position.longitude);

    List<String> placeIds = await _storeService.getStore();

    List<Marker> markers = await _locationService.fetchPetshopsByPlaceIds(placeIds);

    setState(() {
      _userLocation = userLatLng;
      _markers = markers.toSet();
      _isLoading = false;
    });
  } catch (e) {
    print("Erro ao carregar localização e petshops: $e");
    setState(() {
      _isLoading = false;
    });
  }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw "Serviço de localização desativado.";

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) throw "Permissão negada.";
    }

    if (permission == LocationPermission.deniedForever) {
      throw "Permissão permanentemente negada.";
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Petshops Próximos", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _userLocation,
                zoom: 14,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
