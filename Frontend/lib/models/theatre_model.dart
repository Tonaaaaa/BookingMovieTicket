import 'package:google_maps_flutter/google_maps_flutter.dart';

class Theatre {
  final String id;
  final String name;
  final LatLng coordinates;
  final List<String> facilities;
  final String fullAddress;
  final List<String> timings;
  final List<String> availableScreens;

  Theatre({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.facilities,
    required this.fullAddress,
    required this.timings,
    required this.availableScreens,
  });

  factory Theatre.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'].split(',');
    return Theatre(
      id: json['id'],
      name: json['name'],
      coordinates:
          LatLng(double.parse(coordinates[0]), double.parse(coordinates[1])),
      facilities: List<String>.from(json['facilities']),
      fullAddress: json['fullAddress'],
      timings: List<String>.from(json['timings']),
      availableScreens: List<String>.from(json['availableScreens']),
    );
  }
}
