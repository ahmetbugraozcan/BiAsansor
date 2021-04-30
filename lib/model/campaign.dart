import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Campaign {
  String photoLink;
  String bodyText;
  Timestamp campaignDate;
  Campaign(
      {@required this.photoLink,
      @required this.bodyText,
      @required this.campaignDate});

  factory Campaign.fromMap(Map<String, dynamic> map) {
    return Campaign(
        bodyText: map['bodyText'],
        photoLink: map['photoLink'],
        campaignDate: map['campaignDate']);
  }
}
