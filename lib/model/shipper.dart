//Bunları realtime databasede tutabiliriz belki
import 'package:flutter/cupertino.dart';
import 'package:flutter_biasansor/model/comment.dart';

class Shipper {
  int shippingPrice;
  String id;
  String fullName;
  int displayingShippingPrice;
  String name;
  String shippingVehiclePhotoUrl =
      'https://image.flaticon.com/icons/png/512/3629/3629148.png';
  List<int> exceptionFloors;
  List<int> raiseAmounts;
  int maxFloor;
  int workExperience;
  int secondShippingDiscount;
  double rating;
  List<Comment> comments;
  List<String> locations;
  String aboutUsText;
  String phoneNumber;
  Shipper(
      {this.aboutUsText,
      @required this.phoneNumber,
      @required this.locations,
      @required this.raiseAmounts,
      @required this.exceptionFloors,
      @required this.id,
      @required this.shippingPrice,
      @required this.fullName,
      @required this.name,
      @required this.shippingVehiclePhotoUrl,
      @required this.maxFloor,
      @required this.workExperience,
      @required this.secondShippingDiscount});

  List<String> reservedShippingDates;
  @override
  String toString() {
    return 'Nakliyecinin adı : ' +
        name +
        ' Fiyatı : ' +
        shippingPrice.toString() +
        ' yeri : ' +
        locations.toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'aboutUsText': aboutUsText ?? '',
      'locations': locations,
      'raiseAmounts': raiseAmounts,
      'exceptionFloors': exceptionFloors,
      'id': id,
      'workExperience': workExperience,
      'maxFloor': maxFloor,
      'shippingPrice': shippingPrice,
      'shippingVehiclePhotoUrl': shippingVehiclePhotoUrl ??
          'https://cdn.onlinewebfonts.com/svg/img_264570.png',
      'name': name,
      'secondShippingDiscount': secondShippingDiscount,
    };
  }

  Shipper.fromMap(Map<String, dynamic> map)
      : workExperience = map['workExperience'],
        fullName = map['fullName'],
        phoneNumber = map['phoneNumber'],
        maxFloor = map['maxFloor'],
        aboutUsText = map['aboutUsText'] ?? '',
        id = map['id'],
        shippingPrice = map['shippingPrice'],
        shippingVehiclePhotoUrl = map['shippingVehiclePhotoUrl'],
        name = map['name'],
        secondShippingDiscount = map['secondShippingDiscount'],
        exceptionFloors =
            List<int>.from(map['exceptionFloors'] as Iterable<dynamic>)
                .toList(),
        raiseAmounts =
            List<int>.from(map['raiseAmounts'] as Iterable<dynamic>).toList(),
        locations =
            List<String>.from(map['locations'] as Iterable<dynamic>).toList();
}
