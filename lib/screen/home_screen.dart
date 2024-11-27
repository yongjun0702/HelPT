import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpt/main.dart';
import 'package:helpt/screen/exercise_screen.dart';
import 'package:helpt/screen/setting_screen.dart';
import 'package:intl/intl.dart';
import 'package:helpt/config/color.dart';
import 'package:helpt/widget/exercise_result_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userName;
  String? _uid;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        _uid = currentUser.uid; // 유저의 UID 설정
        _userName = currentUser.displayName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayName = (_userName?.length ?? 0) > 10
        ? '${_userName!.substring(0, 10)}...'
        : _userName ?? '사용자';

    return Scaffold(
      backgroundColor: HelPT.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: HelPT.background,
        title: Text(
          "HelPT",
          style: TextStyle(
            color: HelPT.mainBlue,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingScreen(),
                  ),
                );
              },
              child: Icon(Icons.settings, color: HelPT.mainBlue),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: HelPT.tapBackgroud,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          width: 80,
                          height: 80,
                          child: Image.asset("assets/img/logo.png")),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                            text: '$displayName님',
                            style: TextStyle(
                                fontSize: 17, color: HelPT.lightgrey3),
                          ),
                          TextSpan(
                              text: '\n측정을 시작해볼까요?',
                              style: TextStyle(
                                  fontSize: ratio.width * 25,
                                  color: HelPT.mainBlue,
                                  fontWeight: FontWeight.bold)),
                        ])),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseScreen(),
                      ));
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // border: Border.all(width: 1.5, color: HelPT.mainBlue),
                    color: HelPT.tapBackgroud,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_center_focus,
                          color: HelPT.lightgrey4,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "측정 하기",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: HelPT.lightgrey4,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward, color: HelPT.lightgrey4),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              ExerciseResultWidget(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
