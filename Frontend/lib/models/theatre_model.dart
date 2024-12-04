class Theatre {
  final int id;
  final String name;
  final String fullAddress;
  final String? coordinates;
  final List<String> facilities;
  final List<String> availableScreens;
  final String? contactNumber;
  final String? city;
  final String? imageUrl;

  Theatre({
    required this.id,
    required this.name,
    required this.fullAddress,
    this.coordinates,
    required this.facilities,
    required this.availableScreens,
    this.contactNumber,
    this.city,
    this.imageUrl,
  });

  factory Theatre.fromJson(Map<String, dynamic> json) {
    String? baseUrl = "http://10.0.2.2:5130";
    String? imageUrl = json['ImageUrl'] != null
        ? Uri.parse(baseUrl).resolve(json['ImageUrl']).toString()
        : null;

    final facilities = (json['FacilityList'] as List?)
            ?.map((e) => e.toString().trim())
            .toList() ??
        [];
    final availableScreens = (json['AvailableScreensList'] as List?)
            ?.map((e) => e.toString().trim())
            .toList() ??
        [];

    return Theatre(
      id: json['Id'],
      name: json['Name'] ?? 'Unknown',
      fullAddress: json['FullAddress'] ?? '',
      coordinates: json['Coordinates'],
      facilities: facilities,
      availableScreens: availableScreens,
      contactNumber: json['ContactNumber'],
      city: json['City'],
      imageUrl: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'FullAddress': fullAddress,
      'Coordinates': coordinates,
      'FacilityList': facilities,
      'AvailableScreensList': availableScreens,
      'ContactNumber': contactNumber,
      'City': city,
      'ImageUrl': imageUrl,
    };
  }
}
