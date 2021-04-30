import 'package:flutter/cupertino.dart';

class Rating {
  double rating;
  String shipperID;
  String userID;

  Rating(
      {@required this.rating, @required this.shipperID, @required this.userID});
  String toString() {
    return 'Rating : ' +
        rating.toString() +
        ' shipperID : ' +
        shipperID +
        ' userID' +
        userID;
  }

  Rating.fromMap(Map<String, dynamic> map)
      : shipperID = map['shipperID'],
        userID = map['userID'],
        rating = map['rating'];

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'shipperID': shipperID,
      'userID': userID,
    };
  }
}
