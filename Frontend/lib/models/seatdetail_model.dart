class SeatDetail {
  final String seatNumber;
  final String type; // Regular, VIP, Couple
  final String status; // available, booked
  final String? linkedSeatNumber; // Ghế liên kết (dành cho ghế đôi)

  SeatDetail({
    required this.seatNumber,
    required this.type,
    required this.status,
    this.linkedSeatNumber,
  });

  factory SeatDetail.fromJson(Map<String, dynamic> json) {
    return SeatDetail(
      seatNumber: json['seatNumber'] ?? '',
      type: json['type'] ?? 'Regular',
      status: json['status'] ?? 'available',
      linkedSeatNumber: json['linkedSeatNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seatNumber': seatNumber,
      'type': type,
      'status': status,
      'linkedSeatNumber': linkedSeatNumber,
    };
  }
}
