import 'package:bookingmovieticket/models/movie_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieController extends GetxController {
  var isLoading = true.obs;
  var movies = <Movie>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      isLoading(true);
      var url = Uri.parse(
          "http://10.0.2.2:5130/api/movies"); // Địa chỉ localhost cho Android Emulator
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        movies.value = List<Movie>.from(
          jsonData.map((item) => Movie.fromJson(item)),
        );
        print("Movies fetched: ${movies.length}"); // Log số lượng phim
      } else {
        print("Failed to fetch movies: ${response.statusCode}");
        Get.snackbar('Error', 'Failed to fetch movies: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching movies: $e");
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
