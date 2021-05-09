import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Blog {
  String title;
  String bodyText;
  String blogID;
  Timestamp blogTime;
  String blogPhotoLink;
  String blogLink;
  Blog(
      {@required this.title,
      @required this.bodyText,
      @required this.blogLink,
      this.blogID,
      this.blogTime,
      this.blogPhotoLink});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'bodyText': bodyText,
      'blogID': blogID,
      'blogTime': blogTime,
      'blogLink': blogLink,
    };
  }

  factory Blog.fromMap(Map<String, dynamic> map) {
    return Blog(
        title: map['title'],
        blogLink: map['blogLink'],
        bodyText: map['bodyText'],
        blogID: map['blogID'],
        blogTime: map['blogTime']);
  }
}
