import 'package:bookingmovieticket/pages/list_cinema_screen.dart';
import 'package:bookingmovieticket/pages/trailer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/movie_model.dart';

class DetailsScreen extends StatelessWidget {
  final Movie model = Get.arguments as Movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Thông tin phim",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMovieHeader(context),
            buildDetailsSection(),
            const SizedBox(height: 16),
            buildRatingSection(),
            const SizedBox(height: 16),
            buildMovieDescription(),
            const SizedBox(height: 16),
            buildActorsSection(),
            const SizedBox(height: 16),
            buildBuyTicketButton(),
          ],
        ),
      ),
    );
  }

  // Header chứa tên phim, poster và nút trailer
  Widget buildMovieHeader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              model.bannerUrl ?? 'https://via.placeholder.com/150',
              width: 100,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.error, size: 100),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  model.genres.join(", "),
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: getAgeRatingColor(model.ageRating),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        model.ageRating ?? "N/A",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        getAgeRatingDescription(model.ageRating),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (model.trailerUrl != null &&
                            model.trailerUrl!.isNotEmpty) {
                          Get.to(() =>
                              TrailerScreen(trailerUrl: model.trailerUrl!));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Trailer không khả dụng")),
                          );
                        }
                      },
                      icon: const Icon(Icons.play_circle_fill),
                      label: const Text("Trailer"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailsSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Ngày khởi chiếu
          Expanded(
            child: Column(
              children: [
                const Text(
                  "Ngày khởi chiếu",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  "${model.releaseDate.day}/${model.releaseDate.month}/${model.releaseDate.year}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Line đứng 1
          SizedBox(
            height: 40, // Chiều cao của line đứng
            child: const VerticalDivider(
              thickness: 1,
              width: 10, // Không gian giữa line và các mục
              color: Colors.grey, // Màu của line đứng
            ),
          ),
          // Thời lượng
          Expanded(
            child: Column(
              children: [
                const Text(
                  "Thời lượng",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  "${model.durationInMinutes} phút",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Line đứng 2
          SizedBox(
            height: 40, // Chiều cao của line đứng
            child: const VerticalDivider(
              thickness: 1,
              width: 10, // Không gian giữa line và các mục
              color: Colors.grey, // Màu của line đứng
            ),
          ),
          // Ngôn ngữ
          Expanded(
            child: Column(
              children: [
                const Text(
                  "Ngôn ngữ",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  model.languagesAvailable.isNotEmpty
                      ? model.languagesAvailable.join(", ")
                      : "Không có",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRatingSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "6.3",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star, color: Colors.amber, size: 36),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "461 đánh giá",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget buildMovieDescription() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nội dung phim",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            model.description ?? "Không có mô tả.",
            textAlign: TextAlign.justify,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget buildActorsSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Đạo diễn & Diễn viên",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: model.actors.map((actor) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          actor.profilePictureUrl ??
                              'https://via.placeholder.com/100',
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, size: 100);
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 100,
                        child: Text(
                          actor.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBuyTicketButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Chuyển sang trang ListCinemaScreen
            Get.to(() => ListCinemaScreen(model: model));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            "Mua vé",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Hàm lấy màu sắc phân loại độ tuổi
  Color getAgeRatingColor(String? ageRating) {
    switch (ageRating) {
      case "P":
        return Colors.green;
      case "C13":
        return Colors.yellow;
      case "C18":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Hàm lấy mô tả phân loại độ tuổi
  String getAgeRatingDescription(String? ageRating) {
    switch (ageRating) {
      case "P":
        return "Phim được phép phổ biến đến người xem ở mọi độ tuổi.";
      case "C13":
        return "Phim được phổ biến đến người xem từ đủ 13 tuổi trở lên.";
      case "C18":
        return "Phim được phổ biến đến người xem từ đủ 18 tuổi trở lên.";
      default:
        return "Không có thông tin phân loại độ tuổi.";
    }
  }
}
