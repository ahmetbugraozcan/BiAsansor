import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Comment {
  String commentText = '';
  String commenterID;
  String commenterUserName;
  String commentedShipperID;
  double rating;
  Timestamp commentDate;
  Comment({
    @required this.commenterID,
    @required this.commentedShipperID,
    @required this.rating,
    @required this.commentDate,
    @required this.commentText,
    @required this.commenterUserName,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
        commentText: map['commentText'],
        commenterID: map['commenterID'],
        commentedShipperID: map['commentedShipperID'],
        commenterUserName: map['commenterUserName'],
        rating: map['rating'],
        commentDate: map['commentDate']);
  }
  Map<String, dynamic> toMap() {
    return {
      'commentText': commentText,
      'commenterID': commenterID,
      'commentedShipperID': commentedShipperID,
      'commenterUserName': commenterUserName,
      'rating': rating,
      'commentDate': commentDate
    };
  }
}
