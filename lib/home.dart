import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:park_wise/widget/searchcontainer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoggedIn = true;
  double? _currentPositionLat;
  double? _currentPositionLon;
  List<Marker> markers = [];
  double? _carlat;
  double? _carlon;
  MapController mapController = MapController();

  Future<void> isLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
  }

  @override
  void initState() {
    super.initState();
    _askForLocation();
    isLogged();
  }

  Future<void> _askForLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen((Position position) {
        setState(() {
          _currentPositionLat = position.latitude;
          _currentPositionLon = position.longitude;
        });
        print("Lon Lat $_currentPositionLat $_currentPositionLon");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_currentPositionLat != null && _currentPositionLon != null)
          ? Stack(
              children: [
                FlutterMap(
                  mapController: mapController,

                  options: MapOptions(
                    initialZoom: 15,
                    initialCenter: LatLng(
                      _currentPositionLat!,
                      _currentPositionLon!,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.park_wise',
                    ),

                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(
                            _currentPositionLat!,
                            _currentPositionLon!,
                          ),
                          child: const Icon(
                            Icons.location_on,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                        ...markers,
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 60,
                  left: 20,
                  right: 20,
                  child: Searchcontainer(),
                ),
                Positioned(
                  bottom: 40,
                  right: 40,
                  child: FloatingActionButton(
                    onPressed: () {
                      _carlat = _currentPositionLat;
                      _carlon = _currentPositionLon;

                      setState(() {
                        markers.add(
                          Marker(
                            point: LatLng(_carlat!, _carlon!),
                            child: const Icon(
                              Icons.directions_car,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                        );
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Car location saved!')),
                      );

                      print("Car saved at $_carlat, $_carlon");
                    },
                    child: Icon(Icons.car_repair),
                  ),
                ),
              ],
            )
          : CircularProgressIndicator(),
    );
  }
}
