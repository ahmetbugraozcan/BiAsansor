import 'package:flutter_biasansor/model/useracc.dart';
import 'package:flutter_biasansor/services/auth_base.dart';

class FakeAuthenticationService implements AuthBase {
  String userID = "123451512";
  @override
  Future<UserAcc> createUserWithEmailAndPassword(
      String email, String sifre, String fullName) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => UserAcc(
            userID: "created_user_id_123456", email: "fakeuser@fake.com"));
  }

  @override
  Future<UserAcc> currentUser() async {
    return await Future.value(
        UserAcc(userID: userID, email: "fakeuser@fake.com"));
  }

  @override
  Future<UserAcc> signInWithEmailAndPassword(String email, String sifre) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => UserAcc(
            userID: "signIn_user_id_123456", email: "fakeuser@fake.com"));
  }

  @override
  Future<UserAcc> signInWithFacebook() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => UserAcc(
            userID: "facebook_user_id_123456", email: "fakeuser@fake.com"));
  }

  @override
  Future<UserAcc> signInWithGoogle() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => UserAcc(
            userID: "google_user_id_123456", email: "fakeuser@fake.com"));
  }

  @override
  Future<bool> signOut() async {
    return Future.value(true);
  }

  @override
  Future<bool> sendEmailVerification() {
    return Future.value(true);
  }

  @override
  Future<bool> checkEmailVerification() {
    return Future.value(true);
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) {
    return Future.value(true);
  }
}
