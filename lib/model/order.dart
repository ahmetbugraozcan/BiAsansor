import 'package:flutter/cupertino.dart';

class Order {
  String address;
  DateTime dateAndTime;
  int transportationCount;
  List<int> floorsToTransport;
  Order(
      {@required this.address,
      @required this.dateAndTime,
      @required this.transportationCount,
      @required this.floorsToTransport});
}
