import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/showtime.dart';

class ShowtimeController extends GetxController {
  var isLoading = false.obs;
  var showtimes = <Showtime>[].obs;

  final String apiUrl = "http://10.0.2.2:5130/api/showtimes";

  @override
  void onInit() {
    super.onInit();
    fetchShowtimes();
  }

  Future<void> fetchShowtimes() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body != null && body is List) {
          showtimes.value = body
              .map((json) {
                try {
                  return Showtime.fromJson(json);
                } catch (e) {
                  debugPrint("Error parsing Showtime item: $e");
                  return null;
                }
              })
              .where((item) => item != null)
              .cast<Showtime>()
              .toList();
        } else {
          showtimes.value = [];
          Get.snackbar(
            "Error",
            "Unexpected data format or empty data from API.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch showtimes: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch showtimes: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<Showtime> filterShowtimesByTheatreDateAndTimeRange(
      int theatreId, DateTime date, String timeRange) {
    final now = DateTime.now();

    final filteredShowtimes = showtimes.where((showtime) {
      final isSameTheatre = showtime.theatreId == theatreId;
      final isSameDate = showtime.startTime.year == date.year &&
          showtime.startTime.month == date.month &&
          showtime.startTime.day == date.day;

      final isAfterNow = (date.day == now.day &&
              date.month == now.month &&
              date.year == now.year)
          ? (showtime.startTime.isAfter(now) ||
              showtime.startTime.isAtSameMomentAs(now))
          : true;

      return isSameTheatre && isSameDate && isAfterNow;
    }).toList();

    if (timeRange == "Tất cả") return filteredShowtimes;

    final timeRangeParts = timeRange.split(' - ');
    final startHour = int.parse(timeRangeParts[0].split(':')[0]);
    final endHour = int.parse(timeRangeParts[1].split(':')[0]);

    return filteredShowtimes.where((showtime) {
      final startTimeHour = showtime.startTime.hour;
      return startTimeHour >= startHour && startTimeHour < endHour;
    }).toList();
  }
}
