import 'dart:convert';
import 'package:bookingmovieticket/models/theatre_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TheatreController extends GetxController {
  final String baseUrl = "http://<your-api-url>/api/Theatre";

  var theatres = <Theatre>[].obs; // Danh sách rạp
  var isLoading = false.obs; // Trạng thái tải dữ liệu

  @override
  void onInit() {
    super.onInit();
    fetchTheatres(); // Lấy danh sách rạp khi khởi tạo
  }

  // Lấy danh sách rạp
  Future<void> fetchTheatres() async {
    try {
      isLoading(true); // Bắt đầu tải
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        theatres.value = data.map((json) => Theatre.fromJson(json)).toList();
      } else {
        Get.snackbar("Error", "Failed to load theatres");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false); // Kết thúc tải
    }
  }

  // Lấy thông tin rạp theo ID
  Future<Theatre?> getTheatreById(String id) async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return Theatre.fromJson(json.decode(response.body));
      } else {
        Get.snackbar("Error", "Failed to fetch theatre");
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    } finally {
      isLoading(false);
    }
  }
}
