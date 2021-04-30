import 'package:flutter/cupertino.dart';
import 'package:flutter_biasansor/model/rating.dart';

class ShipperMini {
  List<String> locations;
  int shippingPrice;
  String id;
  int displayingShippingPrice;
  String name;
  String shippingVehiclePhotoUrl =
      'https://image.flaticon.com/icons/png/512/3629/3629148.png';
  int maxFloor;
  int workExperience;
  int secondShippingDiscount;
  List<int> exceptionFloors;
  List<int> raiseAmounts;
  double rating;

  ShipperMini({
    @required this.exceptionFloors,
    @required this.raiseAmounts,
    @required this.locations,
    @required this.id,
    @required this.shippingPrice,
    @required this.name,
    @required this.shippingVehiclePhotoUrl,
    @required this.maxFloor,
    @required this.workExperience,
    @required this.secondShippingDiscount,
  });

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
      'id': id,
      'workExperience': workExperience,
      'maxFloor': maxFloor,
      'locations': locations,
      'raiseAmounts': raiseAmounts,
      'exceptionFloors': exceptionFloors,
      'shippingPrice': shippingPrice,
      'shippingVehiclePhotoUrl': shippingVehiclePhotoUrl ??
          'https://cdn.onlinewebfonts.com/svg/img_264570.png',
      'name': name,
      'secondShippingDiscount': secondShippingDiscount,
    };
  }

  ShipperMini.fromMap(Map<String, dynamic> map)
      : workExperience = map['workExperience'],
        id = map['id'],
        locations =
            List<String>.from(map['locations'] as Iterable<dynamic>).toList(),
        exceptionFloors =
            List<int>.from(map['exceptionFloors'] as Iterable<dynamic>)
                .toList(),
        raiseAmounts =
            List<int>.from(map['raiseAmounts'] as Iterable<dynamic>).toList(),
        maxFloor = map['maxFloor'],
        shippingPrice = map['shippingPrice'],
        shippingVehiclePhotoUrl = map['shippingVehiclePhotoUrl'],
        name = map['name'],
        secondShippingDiscount = map['secondShippingDiscount'];
}
