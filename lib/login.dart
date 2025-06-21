import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:park_wise/element/logincontainer.dart';
import 'package:park_wise/home.dart';
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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Google sign in error $e");
      return null;
    }
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
                  child: GestureDetector(
                    onTap: () async {
                      final user = await signInWithGoogle();
                      if (user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      }
                    },
                    child: Logincontainer(),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
