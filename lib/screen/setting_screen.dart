import 'package:helpt/main.dart';
import 'package:helpt/widget/dialog_widget.dart';
import 'package:helpt/widget/privacy_policy_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helpt/service/auth_provider.dart';
import 'package:helpt/widget/button_widget.dart'; // CustomButton 사용
import 'package:helpt/config/color.dart'; // mainBlue 사용
import 'package:helpt/screen/login_screen.dart'; // LoginScreen import

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final String? photoURL = authProvider.user?.photoURL; // 사용자 이미지 URL

    void _showPrivacyPolicy() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // 스크롤 가능하게 설정
        builder: (BuildContext context) {
          return const PrivacyPolicyBottomSheet(); // 바텀시트 위젯 호출
        },
      );
    }

    void _showTermPolicy() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // 스크롤 가능하게 설정
        builder: (BuildContext context) {
          return const TermPolicyBottomSheet(); // 바텀시트 위젯 호출
        },
      );
    }
    void _showDeveloper() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // 스크롤 가능하게 설정
        builder: (BuildContext context) {
          return const DeveloperBottomSheet(); // 바텀시트 위젯 호출
        },
      );
    }

    return Scaffold(
      backgroundColor: HelPT.background,
      appBar: AppBar(
        title: Text("설정", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: HelPT.background,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: HelPT.tapBackgroud,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(children: [
                    CircleAvatar(
                      backgroundImage: photoURL != null && photoURL.isNotEmpty
                          ? NetworkImage(photoURL)
                          : AssetImage('assets/img/settings.png')
                      as ImageProvider,
                      // 기본 이미지 추가
                      radius: 50,
                      backgroundColor: Colors.grey[300], // 배경 색상 설정
                    ),
                    SizedBox(height: 16),
                    Text(
                      authProvider.user?.displayName ?? '사용자 이름',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: HelPT.mainBlue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      authProvider.user?.email ?? '이메일 정보 없음',
                      style: TextStyle(
                        fontSize: 16,
                        color: HelPT.subBlue,
                      ),
                    ),
                  ]),
                ),
              ),
              SizedBox(height: ratio.height * 15),
              GestureDetector(
                onTap: () async {
                  CustomDialog(
                      context: context,
                      title: "로그아웃",
                      dialogContent: "로그아웃 하시겠습니까?",
                      buttonText: "확인",
                      buttonCount: 2,
                      func: () async {
                        try {
                          await authProvider.signOut();
                          // 로그아웃 성공 후 LoginScreen으로 이동
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                                  (route) => false);
                        } catch (e) {
                          print("로그아웃 실패: $e");
                        }
                      });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HelPT.tapBackgroud,
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "로그아웃",
                          style: TextStyle(
                            fontSize: ratio.height * 20,
                            fontWeight: FontWeight.bold,
                            color: HelPT.mainBlue,
                          ),
                        ),
                        Spacer(),
                        Image.asset("assets/img/navigation.png", color: HelPT.mainBlue,),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  CustomDialog(
                      context: context,
                      title: "회원탈퇴",
                      dialogContent: "탈퇴 하시겠습니까?",
                      buttonText: "확인",
                      buttonCount: 2,
                      func: () async {
                        try {
                          await authProvider.deleteAccount();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                                (route) => false,
                          );
                        } catch (e) {
                          print("회원탈퇴 실패: $e");
                        }
                      });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HelPT.tapBackgroud,
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "회원탈퇴",
                          style: TextStyle(
                            fontSize: ratio.height * 20,
                            fontWeight: FontWeight.bold,
                            color: HelPT.mainBlue,
                          ),
                        ),
                        Spacer(),
                        Image.asset("assets/img/navigation.png", color: HelPT.mainBlue,),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: ratio.height * 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          _showPrivacyPolicy();
                        },
                        child: Text(
                          "개인정보처리방침",
                          style: TextStyle(color: HelPT.subBlue, fontSize: 18),
                        )),
                    SizedBox(height: ratio.height * 5),
                    GestureDetector(
                        onTap: () {
                          _showTermPolicy();
                        },
                        child: Text(
                          "서비스 이용약관",
                          style: TextStyle(color: HelPT.subBlue, fontSize: 18),
                        )),
                    SizedBox(height: ratio.height * 5),
                    GestureDetector(
                        onTap: () {
                          _showDeveloper();
                        },
                        child: Text(
                          "개발자 정보",
                          style: TextStyle(color: HelPT.subBlue, fontSize: 18),
                        )),
                    SizedBox(height: ratio.height * 5),
                    Text(
                      "ver 1.0.1",
                      style: TextStyle(color: HelPT.subBlue, fontSize: 18),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
