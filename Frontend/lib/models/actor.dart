class Actor {
  final int id;
  final String name;
  final String image;

  Actor({
    required this.id,
    required this.name,
    required this.image,
  });

  // From JSON
  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
