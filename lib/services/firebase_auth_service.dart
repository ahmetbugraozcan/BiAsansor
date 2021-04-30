import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_biasansor/model/useracc.dart';
import 'package:flutter_biasansor/services/auth_base.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserAcc _userFromFirebase(User user) {
    if (user == null) {
      return null;
    } else {
      var _userAcc = UserAcc(email: user.email, userID: user.uid);
      return _userAcc;
    }
  }

  @override
  Future<UserAcc> createUserWithEmailAndPassword(
      String email, String sifre, String fullName) async {
    var _createdUserAcc = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: sifre);
    var _user = _userFromFirebase(_createdUserAcc.user);
    _user.fullName = fullName;
    return _user;
  }

  @override
  Future<UserAcc> currentUser() async {
    try {
      var _currentUser = await _firebaseAuth.currentUser;
      var _userAcc = _userFromFirebase(_currentUser);
      return _userAcc;
    } catch (ex) {
      print("HATA currentuser in firebase auth service");
    }
  }

  @override
  Future<UserAcc> signInWithEmailAndPassword(String email, String sifre) async {
    var _userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: sifre);
    var _userAcc = _userCredential.user;
    var _user = _userFromFirebase(_userAcc);
    return _user;
  }

  @override
  Future<UserAcc> signInWithFacebook() async {
    var facebookSignIn = FacebookLogin();
    //facebook adını vs de alabiliriz
    final facebookLoginResult =
        await facebookSignIn.logIn(['public_profile', 'email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.loggedIn:
        if (facebookLoginResult.accessToken != null) {
          var firebaseFacebookResult = await _firebaseAuth.signInWithCredential(
              FacebookAuthProvider.credential(
                  facebookLoginResult.accessToken.token));
          var _user = firebaseFacebookResult.user;
          var _userAcc = _userFromFirebase(_user);
          _userAcc.fullName = firebaseFacebookResult.user.displayName;
          return _userAcc;
          // return _userFromFirebase(_user);
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Kullanıcı facebook girişi iptal etti");
        break;
      case FacebookLoginStatus.error:
        print("Signinfacebook hata çıktı firebase auth service: " +
            facebookLoginResult.errorMessage);
        break;
    }

    /*
    *
    *  switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        _showMessage('''
         Logged in!

         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }
    * */
  }

  @override
  Future<UserAcc> signInWithGoogle() async {
    /*
    * {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        if (googleAuth.idToken != null && googleAuth.accessToken != null) {
          final GoogleAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          final authResult =
              await _firebaseAuth.signInWithCredential(credential);
          //Bunu userin kullanıcı adı olarak kullanabiliriz.
          print("User ad : " + authResult.user.displayName);
          UserAcc _userAcc = _userFromFirebase(authResult.user);
          _userAcc.fullName = authResult.user.displayName;
          return _userAcc;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }*/
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser.authentication;

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final authResult = await _firebaseAuth.signInWithCredential(credential);
      //Bunu userin kullanıcı adı olarak kullanabiliriz.
      print("User ad : " + authResult.user.displayName);
      var _userAcc = _userFromFirebase(authResult.user);
      _userAcc.fullName = authResult.user.displayName;
      return _userAcc;
    } catch (ex) {
      print(ex.toString());
    }
  }

  @override
  Future<bool> signOut() async {
    final _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    final _facebookSignIn = FacebookLogin();
    await _facebookSignIn.logOut();
    await _firebaseAuth.signOut();
    return true;
    //facebook girişi de gelecek
  }

  @override
  Future<bool> sendEmailVerification() async {
    var currentUser = await _firebaseAuth.currentUser;
    await currentUser.sendEmailVerification();
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
