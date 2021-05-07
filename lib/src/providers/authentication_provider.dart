import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth;
  AuthenticationProvider(this._auth);

  User get userState => _auth.currentUser;

  // 이메일/비밀번호로 Firebase에 회원가입
  Future<String> signUp(
      {String username, String email, String password}) async {
    String errorMessage;

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        userCredential.user.sendEmailVerification();
        userCredential.user.updateProfile(displayName: username);
        try {
          await _firestore.collection("user").doc(userCredential.user.uid).set({
            "username": username,
            "email": email,
          });
        } on FirebaseException catch (e) {
          // e.g, e.code == 'canceled'
        }
        return errorMessage = null;
      }
    } catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          errorMessage = "동일한 이메일이 등록되어 있습니다";
          break;
        case "invalid-email":
          errorMessage = "이메일 주소가 유효하지 않습니다";
          break;
        case "operation-not-allowed":
          errorMessage = "이메일 주소와 비밀번호를 사용할 수 없습니다";
          break;
        case "weak-password":
          errorMessage = "비밀번호가 안전하지 않습니다";
          break;
        default:
          errorMessage = "이메일 주소와 비밀번호를 확인해주세요";
      }
    }
    return errorMessage;
  }

  // 이메일/비밀번호로 Firebase에 로그인
  Future<String> signIn({String email, String password}) async {
    String errorMessage;

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null && userCredential.user.emailVerified) {
        return errorMessage = null;
      } else {
        userCredential.user.sendEmailVerification();
        return "이메일 주소 인증이 필요합니다";
      }
    } catch (e) {
      switch (e.code) {
        case "invalid-email":
          errorMessage = "이메일 주소가 잘못되었습니다";
          break;
        case "wrong-password":
          errorMessage = "비밀번호가 잘못되었습니다";
          break;
        case "user-not-found":
          errorMessage = "등록되지 않은 이메일 주소입니다";
          break;
        case "user-disabled":
          errorMessage = "비활성화 된 이메일 주소입니다";
          break;
        default:
          errorMessage = "이메일 주소와 비밀번호를 확인해주세요";
      }
    }
    return errorMessage;
  }

  // Firebase로부터 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
