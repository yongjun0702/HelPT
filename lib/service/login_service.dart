import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google 로그인을 처리하는 메서드 (웹 지원 추가)
  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // 웹에서 Firebase Auth Google Sign-In 처리
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();

        // 팝업으로 구글 로그인
        final UserCredential userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
        return userCredential.user;
      } else {
        // 모바일에서 Google 로그인 처리
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return null; // 사용자가 로그인 취소 시 null 반환
        }

        // 인증 정보 가져오기
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Firebase 인증 자격 증명 생성
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Firebase에 로그인 처리
        final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        return userCredential.user;
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }

  // Google 재인증을 처리하는 메서드 (회원탈퇴나 중요한 작업 전에 필요)
  Future<void> reauthenticateWithGoogle() async {
    try {
      if (kIsWeb) {
        // 웹에서는 팝업을 사용하여 재인증
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();

        // Firebase 재인증 처리 (웹)
        final UserCredential? userCredential = await _firebaseAuth.currentUser?.reauthenticateWithPopup(googleProvider);
        if (userCredential == null) {
          throw Exception("Google 재인증 실패: 재인증 중 오류 발생");
        }

        print("Google 재인증 성공 (웹)");
      } else {
        // 모바일에서는 GoogleSignIn을 통해 재인증 처리
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          throw Exception("Google 재인증 실패: 사용자 선택 취소"); // 사용자가 인증 취소 시 예외 발생
        }

        // 인증 정보 가져오기
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Firebase 재인증 자격 증명 생성
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // 현재 사용자의 자격 증명 재인증
        await _firebaseAuth.currentUser?.reauthenticateWithCredential(credential);
        print("Google 재인증 성공 (모바일)");
      }
    } catch (e) {
      print("Google 재인증 실패: $e"); // 에러 로그 출력
      throw e;
    }
  }

  // 회원탈퇴 기능 (재인증 후 계정 삭제)
  Future<void> deleteAccount() async {
    try {
      // 현재 사용자 계정 삭제
      await _firebaseAuth.currentUser?.delete();
      print("회원탈퇴 성공");
    } catch (e) {
      print("회원탈퇴 실패: $e"); // 에러 로그 출력
      throw e;
    }
  }

  // 로그아웃 처리
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
  }

  // 현재 로그인된 사용자 정보 반환
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
