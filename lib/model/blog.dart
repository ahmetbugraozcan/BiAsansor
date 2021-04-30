import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Blog {
  String title;
  String bodyText;
  String blogID;
  Timestamp blogTime;
  String blogPhotoLink;
  Blog(
      {@required this.title,
      @required this.bodyText,
      this.blogID,
      this.blogTime,
      this.blogPhotoLink});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'bodyText': bodyText,
      'blogID': blogID,
      'blogTime': blogTime,
    };
  }

  factory Blog.fromMap(Map<String, dynamic> map) {
    return Blog(
        title: map['title'],
        bodyText: map['bodyText'],
        blogID: map['blogID'],
        blogTime: map['blogTime']);
  }
}
