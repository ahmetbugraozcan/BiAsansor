import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FinishedShipping {
  bool isCommented;
  Timestamp shippingDate;
  String shipperID;
  String userID;
  String shipperPhotoUrl;
  String location;
  String shipperName;
  int transportCount;
  List<int> transportedFloors;
  int price;
  //listeden kaldırma işlemi için gerekli olan alan
  String reservationID;
  String phoneNumber;
  FinishedShipping(
      {this.isCommented,
      @required this.price,
      @required this.phoneNumber,
      @required this.shipperName,
      @required this.shippingDate,
      @required this.shipperID,
      @required this.userID,
      @required this.shipperPhotoUrl,
      @required this.location,
      @required this.transportCount,
      @required this.transportedFloors});
  FinishedShipping.fromMap(Map<String, dynamic> map)
      : shipperName = map['shipperName'],
        phoneNumber = map['phoneNumber'],
        isCommented = map['isCommented'],
        shippingDate = map['shippingDate'],
        shipperID = map['shipperID'],
        userID = map['userID'],
        shipperPhotoUrl = map['shipperPhotoUrl'],
        location = map['location'],
        transportCount = map['transportCount'],
        price = map['price'],
        transportedFloors =
            List<int>.from(map['transportedFloors'] as Iterable<dynamic>)
                .toList();
  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'phoneNumber': phoneNumber,
      'shipperName': shipperName,
      'isCommented': isCommented ?? false,
      'shippingDate': shippingDate,
      'shipperID': shipperID,
      'userID': userID,
      'shipperPhotoUrl': shipperPhotoUrl,
      'location': location,
      'transportCount': transportCount,
      'transportedFloors': transportedFloors,
    };
  }
}
