import 'package:flutter_biasansor/model/useracc.dart';

abstract class AuthBase {
  Future<UserAcc> currentUser();
  Future<bool> signOut();
  Future<UserAcc> signInWithGoogle();
  Future<UserAcc> signInWithFacebook();
  Future<UserAcc> signInWithEmailAndPassword(String email, String sifre);
  Future<UserAcc> createUserWithEmailAndPassword(
      String email, String sifre, String fullName);
  Future<bool> sendEmailVerification();
  Future<bool> sendPasswordResetEmail(String email);
}
