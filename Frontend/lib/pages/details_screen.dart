import 'dart:convert';
import 'package:bookingmovieticket/pages/list_cinema_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../controllers/vote_controller.dart';
import '../utils/mytheme.dart';
import '../widgets/cast_crew_block.dart';
import '../widgets/offers_block.dart';
import '../widgets/review_block.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen({Key? key}) : super(key: key);

  final MovieController movieController = Get.find<MovieController>();
  final VoteController voteController =
      Get.put(VoteController()); // Khởi tạo VoteController

  // Lấy dữ liệu truyền từ arguments
  final dynamic model = Get.arguments[0];
  final int index = Get.arguments[1];

  @override
  Widget build(BuildContext context) {
    // Gọi hàm fetchVotes để lấy dữ liệu khi mở màn hình
    voteController.fetchVotes(model.title);

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            // Điều hướng tới màn hình đặt vé
            Get.to(() => ListCinemaScreen(model: model));
          },
          child: Container(
            width: double.maxFinite,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/armchair.svg",
                  color: Colors.white,
                  height: 20,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Book Seats",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: MyTheme.splash,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: MyTheme.appBarColor,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            foregroundColor: Colors.white,
            title: Text(model.title ?? "Unknown Title"),
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: "${model.title}$index",
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: model.bannerUrl.startsWith('data:image/')
                          ? MemoryImage(
                              base64Decode(
                                model.bannerUrl.split(',')[1], // Loại bỏ header
                              ),
                            )
                          : NetworkImage(
                              model.bannerUrl ??
                                  "https://via.placeholder.com/150",
                            ) as ImageProvider,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: const Color(0xFFF5F5FA),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    block1(model),
                    const SizedBox(height: 20),
                    const OffersBlock(),
                    const SizedBox(height: 20),
                    const ReviewBlock(),
                    const SizedBox(height: 20),
                    const CrewCastBlock(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị tiêu đề phim và votes
  Widget block1(dynamic model) {
    return Container(
      color: Colors.white,
      width: double.maxFinite,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget(model),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                model.releaseDate ?? "Unknown Date",
                style: const TextStyle(
                  color: Colors.black45,
                ),
              ),
              Obx(() {
                // Sử dụng Obx để lắng nghe sự thay đổi của votes
                return Text(
                  "${voteController.votes.value} votes",
                  style: const TextStyle(
                    color: MyTheme.splash,
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 10),
          screensWidget(model.screens),
          const SizedBox(height: 10),
          descriptionWidget(model),
        ],
      ),
    );
  }

  // Widget hiển thị tiêu đề phim
  Widget titleWidget(dynamic model) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            model.title ?? "Unknown Title",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.favorite,
                color: MyTheme.splash,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "${model.like ?? 0}%",
                style: const TextStyle(fontSize: 10),
              )
            ],
          )
        ],
      );

  // Widget hiển thị thông tin ngôn ngữ và định dạng phim
  Widget screensWidget(List<String>? screens) => Row(
        children: screens?.map((screen) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: MyTheme.splash.withOpacity(0.1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    screen,
                    style: const TextStyle(
                      color: MyTheme.splash,
                    ),
                  ),
                ),
              );
            }).toList() ??
            [],
      );

  // Widget hiển thị mô tả phim
  Widget descriptionWidget(dynamic model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.history,
                size: 15,
                color: Colors.black45,
              ),
              const SizedBox(width: 10),
              Text(
                model.duration ?? "Unknown Duration",
                style: const TextStyle(color: Colors.black45),
              ),
              const SizedBox(width: 10),
              SvgPicture.asset(
                "assets/icons/theater_masks.svg",
                height: 15,
                width: 15,
                color: Colors.black45,
              ),
              const SizedBox(width: 10),
              Text(
                model.genres?.join(", ") ?? "Unknown Genres",
                style: const TextStyle(color: Colors.black45),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            model.description ?? "No Description",
            style: const TextStyle(color: Colors.black45),
          ),
        ],
      );
}
