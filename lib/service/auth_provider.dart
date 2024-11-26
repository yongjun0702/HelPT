import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final LoginService _loginService = LoginService();

  AuthProvider() {
    _initializeUser();
  }

  User? get user => _user;

  String? get uid => _user?.uid;

  void _initializeUser() {
    _user = _loginService.getCurrentUser();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (_user != user) {
        _user = user;
        notifyListeners();
      }
    });
  }


  // Google 로그인을 처리하는 메서드
  Future<void> signInWithGoogle() async {
    try {
      final User? user = await _loginService.signInWithGoogle();
      if (_user != user) {
        _user = user; // 사용자 정보 업데이트
        notifyListeners(); // UI 업데이트
      }
    } catch (e) {
      print('Google 로그인 실패: $e'); // 에러 로그 출력
      rethrow; // 에러를 다시 던져서 상위에서 처리할 수 있게 합니다.
    }
  }

  // 로그아웃 처리 메서드
  Future<void> signOut() async {
    try {
      await _loginService.signOut();
      if (_user != null) {
        _user = null; // 사용자 정보 초기화
        notifyListeners(); // UI 업데이트
      }
    } catch (e) {
      print('로그아웃 실패: $e'); // 에러 로그 출력
      rethrow; // 에러를 다시 던져서 상위에서 처리할 수 있게 합니다.
    }
  }

  // 회원탈퇴 처리 메서드 (Google 재인증 후 삭제)
  Future<void> deleteAccount() async {
    try {
      // Google 재인증 먼저 수행
      await _loginService.reauthenticateWithGoogle();

      // 계정 삭제 처리
      await _loginService.deleteAccount();
      await signOut(); // 계정 삭제 후 로그아웃
    } catch (e) {
      print('회원탈퇴 실패: $e'); // 에러 로그 출력
      rethrow; // 에러를 다시 던져서 상위에서 처리할 수 있게 합니다.
    }
  }

  // 앱 실행 시 사용자의 로그인 상태를 확인하는 메서드
  void checkLoginStatus() {
    final User? currentUser = _loginService.getCurrentUser();
    if (_user != currentUser) {
      _user = currentUser; // 현재 사용자 정보 가져오기
      notifyListeners(); // UI 업데이트
    }
  }
}
