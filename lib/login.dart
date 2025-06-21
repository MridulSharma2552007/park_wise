import 'package:flutter/material.dart';
import 'package:park_wise/element/logincontainer.dart';
import 'package:video_player/video_player.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late VideoPlayerController _controller;
  bool isInitialized = false;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/vids/loginvideo.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setVolume(0);
        _controller.setLooping(true);
        setState(() {
          isInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isInitialized
          ? Stack(
              fit: StackFit.expand,

              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                Positioned(
                  bottom: 40,
                  left: 10,
                  right: 10,
                  child: Logincontainer(),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
