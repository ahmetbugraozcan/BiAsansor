import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MembershipForm {
  String fullName;
  String shippingName;
  String floorPrices;
  int maxFloor;
  int experience;
  String aboutUs;
  String photoUrl;
  List<String> locations;
  String phoneNumber;
  Timestamp formSendingDate;
  MembershipForm(
      {@required this.photoUrl,
      @required this.phoneNumber,
      @required this.fullName,
      @required this.shippingName,
      @required this.floorPrices,
      @required this.maxFloor,
      @required this.experience,
      @required this.aboutUs,
      @required this.locations,
      @required this.formSendingDate});
  String toString() {
    return "Başvuranın adı : $shippingName Fiyatlandırma Tarifesi : $floorPrices En yüksek kat: $maxFloor Tecrübesi: $experience Gittiği Şehirler: $locations";
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'fullName': fullName,
      'shippingName': shippingName,
      'floorPrices': floorPrices,
      'maxFloor': maxFloor,
      'experience': experience,
      'aboutUs': aboutUs,
      'locations': locations,
      'formSendingDate': formSendingDate,
    };
  }

  MembershipForm.fromMap(Map<String, dynamic> map)
      : shippingName = map["shippingName"],
        phoneNumber = map["phoneNumber"],
        photoUrl = map["photoUrl"],
        fullName = map["fullName"],
        floorPrices = map["floorPrices"],
        maxFloor = map["maxFloor"],
        experience = map["experience"],
        aboutUs = map["aboutUs"],
        formSendingDate = map["formSendingDate"],
        locations =
            List<String>.from(map['locations'] as Iterable<dynamic>).toList();
}
