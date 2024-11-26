import 'package:helpt/main.dart';
import 'package:helpt/screen/policy_screen.dart';
import 'package:helpt/service/auth_provider.dart'
as MyAuthProvider; // 사용자 정의 AuthProvider
import 'package:helpt/widget/privacy_policy_widget.dart';
import 'package:helpt/widget/tab_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpt/config/color.dart';
import 'package:helpt/widget/button_widget.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth의 User 클래스 임포트

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double opacityLevel1 = 0.0;
  double opacityLevel2 = 0.0;
  double opacityLevel3 = 0.0;
  double opacityLevel4 = 0.0;

  bool _isAccepted = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      Provider.of<MyAuthProvider.AuthProvider>(context, listen: false)
          .checkLoginStatus();
    }); // 로그인 상태 확인

    // 애니메이션을 순차적으로 시작
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          opacityLevel1 = 1.0;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          opacityLevel2 = 1.0;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() {
          opacityLevel3 = 1.0;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 3800), () {
      if (mounted) {
        setState(() {
          opacityLevel4 = 1.0;
        });
      }
    });
  }

  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 스크롤 가능하게 설정
      builder: (BuildContext context) {
        return const PrivacyPolicyBottomSheet(); // 바텀시트 위젯 호출
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider.AuthProvider>(context);
    final User? _user = authProvider.user; // Firebase Auth의 User 객체

    if (_user == null) {
    }

    return Scaffold(
      backgroundColor: HelPT.background, // 배경 색상 설정
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: _user == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 첫 번째 텍스트
            AnimatedOpacity(
              opacity: opacityLevel1,
              duration: const Duration(seconds: 1),
              child: Text(
                '나만의',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                    color: HelPT.lightgrey2
                ),
              ),
            ),
            // 두 번째 텍스트
            AnimatedOpacity(
              opacity: opacityLevel2,
              duration: const Duration(seconds: 1),
              child: Text(
                '헬스 트레이너',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                    color: HelPT.lightgrey2
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: opacityLevel3,
              duration: const Duration(seconds: 1),
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(Icons.sports_score,
                          color: HelPT.mainBlue,
                          size: 40),
                    ),
                    TextSpan(
                        text: 'HelPT',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: HelPT.mainBlue)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 70),
            AnimatedOpacity(
              opacity: opacityLevel4,
              duration: const Duration(seconds: 1),
              child: Column(children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2, color: HelPT.mainBlue),
                    color: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(Icons.directions_run,
                                    color: HelPT.mainBlue,
                                    size: 20),
                              ),
                              WidgetSpan(
                                  child:
                                  SizedBox(width: 5)),
                              TextSpan(
                                  text: '카메라를 이용해 손쉽게 측정하세요.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: HelPT.lightgrey3)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                    border: Border.all(width: 2, color: HelPT.mainBlue)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(Icons.directions_run,
                                    color: HelPT.mainBlue,
                                    size: 20),
                              ),
                              WidgetSpan(
                                  child:
                                  SizedBox(width: 5)),
                              TextSpan(
                                  text: '운동이 끝나면 종료 버튼을 눌러주세요.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: HelPT.lightgrey3)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                      border: Border.all(width: 2, color: HelPT.mainBlue)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(Icons.directions_run,
                                    color: HelPT.mainBlue,
                                    size: 20),
                              ),
                              WidgetSpan(
                                  child:
                                  SizedBox(width: 5)),
                              TextSpan(
                                  text: '운동 종료 후 기록을 확인하세요.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: HelPT.lightgrey3)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            SizedBox(height: 75),
            AnimatedOpacity(
              opacity: opacityLevel4,
              duration: const Duration(seconds: 1),
              child: GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PolicyScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HelPT.mainBlue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 17, horizontal: 20),
                    child: Center(
                      child: Text(
                        "시작하기",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // child: CustomButton(
              //   text: 'Google 로그인',
              //   width: 150,
              //   height: 50,
              //   buttonCount: 1,
              //   func: () async {
              //     await authProvider.signInWithGoogle(); // Google 로그인 호출
              //     if (authProvider.user != null) {
              //       // 로그인 성공 후 RootTab으로 이동
              //       Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => RootTab(),
              //         ),
              //       );
              //     }
              //   },
              // ),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: '로그아웃',
              width: 150,
              height: 50,
              buttonCount: 1,
              func: () async {
                await authProvider.signOut(); // 로그아웃 호출
              },
            ),
          ],
        ),
      ),
    );
  }
}
