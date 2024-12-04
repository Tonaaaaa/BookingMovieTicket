import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TrailerScreen extends StatefulWidget {
  final String trailerUrl;

  const TrailerScreen({required this.trailerUrl, Key? key}) : super(key: key);

  @override
  _TrailerScreenState createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Sử dụng URL từ server
    _controller = VideoPlayerController.network(widget.trailerUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller?.play(); // Tự động phát sau khi khởi tạo
      }).catchError((error) {
        debugPrint("Error initializing video: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Không thể phát trailer.")),
        );
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trailer"),
      ),
      body: _isInitialized && _controller != null
          ? AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: _isInitialized && _controller != null
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                });
              },
              child: Icon(
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
