import 'package:helpt/config/color.dart';
import 'package:helpt/main.dart';
import 'package:helpt/service/auth_provider.dart'
as MyAuthProvider; // 사용자 정의 AuthProvider
import 'package:helpt/widget/privacy_policy_widget.dart';
import 'package:helpt/widget/tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:helpt/config/color.dart';
import 'package:helpt/main.dart';
import 'package:helpt/widget/privacy_policy_widget.dart';
import 'package:helpt/widget/tab_widget.dart';
import 'package:provider/provider.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  bool _isTermsAccepted = false; // 서비스 이용약관 체크 상태
  bool _isPrivacyAccepted = false; // 개인정보처리방침 체크 상태
  bool _isAllAccepted = false; // 모두 동의 체크 상태

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

  void _updateAllAccepted(bool? value) {
    setState(() {
      _isAllAccepted = value ?? false;
      _isTermsAccepted = _isAllAccepted;
      _isPrivacyAccepted = _isAllAccepted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider.AuthProvider>(context);
    final bool isLoginEnabled = _isTermsAccepted && _isPrivacyAccepted;

    return Scaffold(
      backgroundColor: HelPT.background,
      appBar: AppBar(
        title: Text("회원가입", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: HelPT.background,
        scrolledUnderElevation: 0,
        centerTitle: true,

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '서비스 이용에는\n구글 계정이 필요해요.',
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.bold,
                color: HelPT.lightgrey3
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        "모두 동의",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: HelPT.mainBlue,
                        ),
                      ),
                      Checkbox(
                        activeColor: HelPT.mainBlue,
                        value: _isAllAccepted,
                        onChanged: _updateAllAccepted,
                        side: BorderSide(
                            color: HelPT.mainBlue, width: 2),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _showTermPolicy,
                        child: Row(
                          children: [
                            Text(
                              "서비스 이용약관",
                              style: TextStyle(
                                fontSize: 20,
                                color: HelPT.lightgrey3,
                              ),
                            ),
                            Image.asset("assets/img/navigation.png"),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text(
                        "동의",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: HelPT.mainBlue,
                        ),
                      ),
                      Checkbox(
                        activeColor: HelPT.mainBlue,
                        value: _isTermsAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            _isTermsAccepted = value ?? false;
                            _isAllAccepted =
                                _isTermsAccepted && _isPrivacyAccepted;
                          });
                        },
                        side: BorderSide(
                            color: HelPT.mainBlue, width: 2),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _showPrivacyPolicy,
                        child: Row(
                          children: [
                            Text(
                              "개인정보처리방침",
                              style: TextStyle(
                                fontSize: 20,
                                color: HelPT.lightgrey3,
                              ),
                            ),
                            Image.asset("assets/img/navigation.png"),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text(
                        "동의",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: HelPT.mainBlue,
                        ),
                      ),
                      Checkbox(
                        activeColor: HelPT.mainBlue,
                        value: _isPrivacyAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            _isPrivacyAccepted = value ?? false;
                            _isAllAccepted =
                                _isTermsAccepted && _isPrivacyAccepted;
                          });
                        },
                        side: BorderSide(
                            color: HelPT.mainBlue, width: 2),
                      ),

                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: isLoginEnabled
                  ? () async {
                await authProvider.signInWithGoogle();
                if (authProvider.user != null) {
                  Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => RootTab()),
                      (route) => false,
                );
                }
              }
                  : null,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isLoginEnabled
                      ? HelPT.mainBlue
                      : HelPT.grey1, // 비활성화 시 색상 회색으로 설정
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                  child: Center(
                    child: Text(
                      "구글 계정으로 로그인",
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
          ],
        ),
      ),
    );
  }
}
