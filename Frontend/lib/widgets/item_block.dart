import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class ItemBlock extends StatelessWidget {
  final Movie model; // Model kiểu Movie
  final bool isMovie;
  final double height;
  final double width;
  final Function(Movie model) onTap;

  const ItemBlock({
    Key? key,
    required this.model,
    this.isMovie = false,
    this.height = 150,
    this.width = 120,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Xử lý hình ảnh: kiểm tra xem là URL thông thường hay base64
    Widget imageWidget;
    if (model.bannerUrl != null && model.bannerUrl!.startsWith('data:image')) {
      try {
        final base64Image = model.bannerUrl!.split(',').last;
        imageWidget = Image.memory(
          base64Decode(base64Image), // Decode base64
          height: height,
          width: width,
          fit: BoxFit.cover,
        );
      } catch (e) {
        imageWidget = _errorPlaceholder(); // Hiển thị lỗi nếu decode thất bại
      }
    } else {
      imageWidget = Image.network(
        model.bannerUrl ?? 'https://via.placeholder.com/150',
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _errorPlaceholder(); // Hiển thị lỗi nếu URL không tải được
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20.0, right: 10),
      child: GestureDetector(
        onTap: () {
          onTap(model); // Truyền dữ liệu khi chọn vào phim
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageWidget,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: width,
              child: Text(
                model.title ?? 'No Title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            isMovie
                ? Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 12),
                      const SizedBox(width: 5),
                      Text("${model.like}%",
                          style: const TextStyle(fontSize: 10)),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị khi có lỗi trong hình ảnh
  Widget _errorPlaceholder() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey,
      child: const Icon(Icons.error, color: Colors.red),
    );
  }
}
