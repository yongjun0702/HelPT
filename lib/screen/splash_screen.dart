import 'dart:async';
import 'package:helpt/config/color.dart';
import 'package:helpt/widget/tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:helpt/widget/tab_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    /// <1.5초 뒤 로그인 페이지로 이동>
    Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RootTab()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HelPT.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              child: Image.asset("assets/img/logo.png"),
            ),
          ],
        ),
      ),
    );
  }
}
