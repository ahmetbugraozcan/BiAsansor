import 'package:flutter/cupertino.dart';

class UserAcc {
  String userID;
  String email;
  String userName;
  String profileUrl;
  String location;
  String phoneNumber;
  String fullName;
  bool isAdmin = false;
  UserAcc({@required this.email, @required this.userID});

  Map<String, dynamic> toMap() {
    return {
      'isAdmin': isAdmin,
      'userID': userID,
      'email': email,
      'userName': userName ?? email.split('@')[0],
      'profileUrl':
          profileUrl ?? 'https://cdn.onlinewebfonts.com/svg/img_264570.png',
      'location': location ?? '',
      'phoneNumber': phoneNumber ?? '',
      'fullName': fullName ?? ''
    };
  }

  UserAcc.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        isAdmin = map['isAdmin'],
        email = map['email'],
        userName = map['userName'],
        profileUrl = map['profileUrl'],
        location = map['location'],
        phoneNumber = map['phoneNumber'],
        fullName = map['fullName'];
}
