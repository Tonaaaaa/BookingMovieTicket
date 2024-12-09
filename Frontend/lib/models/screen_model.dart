import 'showtime.dart'; // Nếu bạn đã có model Showtime

class Screen {
  final int id; // ID phòng chiếu
  final String name; // Tên phòng chiếu
  final int theatreId; // Thuộc rạp nào
  final int seatCapacity; // Số lượng ghế
  final List<Showtime>? showtimes; // Danh sách suất chiếu

  Screen({
    required this.id,
    required this.name,
    required this.theatreId,
    required this.seatCapacity,
    this.showtimes,
  });

  // Phương thức để chuyển đổi từ JSON thành Screen
  factory Screen.fromJson(Map<String, dynamic> json) {
    return Screen(
      id: json['id'],
      name: json['name'],
      theatreId: json['theatreId'],
      seatCapacity: json['seatCapacity'],
      showtimes: json['showtimes'] != null
          ? (json['showtimes'] as List)
              .map((e) => Showtime.fromJson(e))
              .toList()
          : null,
    );
  }

  // Phương thức để chuyển đổi từ Screen thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'theatreId': theatreId,
      'seatCapacity': seatCapacity,
      'showtimes': showtimes?.map((e) => e.toJson()).toList(),
    };
  }
}
