import 'package:bookingmovieticket/models/movie_model.dart';

class Showtime {
  final int id;
  final int movieId;
  final int theatreId;
  final String screen;
  final DateTime startTime;
  final DateTime endTime;
  final String format;
  final String showType;
  final int seatCapacity;
  final double ticketPrice;
  final String status;
  final int screenId;
  final Movie? movie;

  Showtime({
    required this.id,
    required this.movieId,
    required this.theatreId,
    required this.screen,
    required this.startTime,
    required this.endTime,
    required this.format,
    required this.showType,
    required this.seatCapacity,
    required this.ticketPrice,
    required this.status,
    required this.screenId,
    this.movie,
  });

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      id: json['Id'] ?? 0,
      movieId: json['MovieId'] ?? 0,
      theatreId: json['TheatreId'] ?? 0,
      screen: json['Screen'] ?? 'N/A',
      startTime: DateTime.tryParse(json['StartTime'] ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['EndTime'] ?? '') ?? DateTime.now(),
      format: json['Format'] ?? 'Unknown',
      showType: json['ShowType'] ?? 'Unknown',
      seatCapacity: json['SeatCapacity'] ?? 0,
      ticketPrice: (json['TicketPrice'] as num?)?.toDouble() ?? 0.0,
      status: json['Status'] ?? 'Inactive',
      screenId: json['ScreenId'] ?? 0,
      movie: json['Movie'] != null ? Movie.fromJson(json['Movie']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'MovieId': movieId,
      'TheatreId': theatreId,
      'Screen': screen,
      'StartTime': startTime.toIso8601String(),
      'EndTime': endTime.toIso8601String(),
      'Format': format,
      'ShowType': showType,
      'SeatCapacity': seatCapacity,
      'TicketPrice': ticketPrice,
      'Status': status,
      'ScreenId': screenId,
      'Movie': movie?.toJson(),
    };
  }
}
