import 'package:flutter/material.dart';
import 'package:flutter_biasansor/model/shipper.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:provider/provider.dart';

class ShipperDetailsForAdmin extends StatefulWidget {
  String id;
  ShipperDetailsForAdmin({@required this.id});
  @override
  _ShipperDetailsForAdminState createState() => _ShipperDetailsForAdminState();
}

class _ShipperDetailsForAdminState extends State<ShipperDetailsForAdmin> {
  @override
  var shipper;
  Widget build(BuildContext context) {
    var _viewModel = Provider.of<ViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Asansörcü Detayları"),
      ),
      body: FutureBuilder(
        future: _viewModel.getShipperDetails(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            shipper = snapshot.data;
            return ListView(
              children: [
                Text(shipper.phoneNumber),
                Text(shipper.name ?? ' null'),
                Text(shipper.fullName ?? ' null'),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
