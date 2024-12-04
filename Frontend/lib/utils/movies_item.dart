import 'package:bookingmovieticket/pages/details_screen.dart';
import 'package:bookingmovieticket/widgets/item_block.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../models/movie_model.dart';

class MyMovieItem extends StatelessWidget {
  final MovieController movieController = Get.put(MovieController());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Obx(() {
      if (movieController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (movieController.movies.isEmpty) {
        return const Center(
          child: Text(
            'Không có phim nào để hiển thị.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      }

      var movies = movieController.movies;

      return SizedBox(
        height: 250,
        width: size.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (_, index) {
            final Movie movie = movies[index];

            return ItemBlock(
              model: movie,
              height: 150,
              width: 120,
              onTap: (selectedMovie) {
                Get.to(
                  () => DetailsScreen(),
                  arguments: selectedMovie,
                );
              },
            );
          },
        ),
      );
    });
  }
}
