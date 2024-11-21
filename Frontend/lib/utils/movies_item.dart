import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../widgets/item_block.dart';
import '../pages/details_screen.dart';

class MyMovieItem extends StatelessWidget {
  const MyMovieItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // Lấy MovieController thông qua GetX
    final MovieController movieController = Get.find<MovieController>();

    return Obx(() {
      // Kiểm tra trạng thái tải dữ liệu
      if (movieController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      // Kiểm tra nếu không có dữ liệu
      if (movieController.movies.isEmpty) {
        return Center(
          child: Text(
            'No movies available.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      }

      // Danh sách phim từ MovieController
      var movies = movieController.movies;

      // Hiển thị danh sách phim
      return Container(
        height: 230,
        width: size.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (_, i) {
            final movie = movies[i];
            return Hero(
              tag: "${movie.title}$i",
              child: ItemBlock(
                model: movie,
                isMovie: true,
                onTap: (model) {
                  Get.to(() => DetailsScreen(), arguments: [movie, i]);
                },
              ),
            );
          },
        ),
      );
    });
  }
}
