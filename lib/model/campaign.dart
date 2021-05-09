import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Campaign {
  String photoLink;
  String campaignID;
  Timestamp campaignDate;
  String campaignLink;
  Campaign({
    @required this.campaignLink,
    this.photoLink,
    this.campaignDate,
    this.campaignID,
  });

  factory Campaign.fromMap(Map<String, dynamic> map) {
    return Campaign(
        campaignLink: map['campaignLink'],
        campaignDate: map['campaignDate'],
        campaignID: map['campaignID']);
  }
  Map<String, dynamic> toMap() {
    return {
      'campaignLink': campaignLink,
      'campaignDate': campaignDate,
      'campaignID': campaignID,
    };
  }

  String toString() {
    return 'Linkimiz : ' +
        campaignLink +
        "datemiz : " +
        campaignDate.toDate().toString();
  }
}
