import 'dart:convert';
import 'package:bookingmovieticket/models/seatdetail_model.dart';
import 'package:http/http.dart' as http;
import '../models/seat_model.dart';

class SeatController {
  final String apiUrl = 'http://10.0.2.2:5130/api/seat'; // Thay URL API của bạn

  /// Lấy danh sách ghế theo `screenId`
  Future<List<List<SeatDetail>>> fetchSeats(int screenId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?screenId=$screenId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Tìm màn hình theo `screenId` và lấy `Arrangement`
        final screenData = data.firstWhere(
          (screen) => screen['ScreenId'] == screenId,
          orElse: () => null,
        );

        if (screenData == null) {
          throw Exception('Screen not found for the given ScreenId');
        }

        // Giải mã `Arrangement` để lấy danh sách ghế
        final arrangementJson = json.decode(screenData['Arrangement']);
        return (arrangementJson as List)
            .map((row) =>
                (row as List).map((seat) => SeatDetail.fromJson(seat)).toList())
            .toList();
      } else {
        throw Exception(
            'Failed to load seats. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching seats: $e');
    }
  }
}
