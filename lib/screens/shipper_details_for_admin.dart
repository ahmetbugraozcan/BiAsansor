import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
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
  Shipper shipper;
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
                ListTile(
                  title: Text("Asansör Şirketinin Adı",
                      style: context.theme.textTheme.headline6
                          .copyWith(color: Colors.blue[900])),
                  subtitle: TextFormField(
                    readOnly: true,
                    initialValue: shipper.name,
                  ),
                ),
                ListTile(
                  title: Text("Asansörcünün Tam Adı",
                      style: context.theme.textTheme.headline6
                          .copyWith(color: Colors.blue[900])),
                  subtitle: TextFormField(
                    readOnly: true,
                    initialValue: shipper.fullName,
                  ),
                ),
                ListTile(
                  title: Text("Telefon Numarası",
                      style: context.theme.textTheme.headline6
                          .copyWith(color: Colors.blue[900])),
                  subtitle: TextFormField(
                    readOnly: true,
                    initialValue: shipper.phoneNumber,
                  ),
                ),
                ListTile(
                  title: Text("Çalıştığı Yerler",
                      style: context.theme.textTheme.headline6
                          .copyWith(color: Colors.blue[900])),
                  subtitle: TextFormField(
                    readOnly: true,
                    initialValue: shipper.locations.toString(),
                  ),
                ),
                ListTile(
                  title: Text("Asansörün Ücreti",
                      style: context.theme.textTheme.headline6
                          .copyWith(color: Colors.blue[900])),
                  subtitle: TextFormField(
                    readOnly: true,
                    initialValue: shipper.shippingPrice.toString(),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Asansörcünün IDsi",
                    style: context.theme.textTheme.headline6
                        .copyWith(color: Colors.blue[900]),
                  ),
                  subtitle: TextFormField(
                    readOnly: true,
                    initialValue: shipper.id,
                  ),
                ),
                ListTile(
                  title: Text(
                    "İkinci Taşıma İndirimi",
                    style: context.theme.textTheme.headline6
                        .copyWith(color: Colors.blue[900]),
                  ),
                  subtitle: TextFormField(
                    readOnly: true,
                    initialValue: shipper.secondShippingDiscount.toString(),
                  ),
                ),
                ListTile(
                  title: Text(
                    "İstisna Katlar",
                    style: context.theme.textTheme.headline6
                        .copyWith(color: Colors.blue[900]),
                  ),
                  subtitle: TextFormField(
                    readOnly: true,
                    initialValue: shipper.exceptionFloors.toString(),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Zam Miktarları",
                    style: context.theme.textTheme.headline6
                        .copyWith(color: Colors.blue[900]),
                  ),
                  subtitle: TextFormField(
                    readOnly: true,
                    initialValue: shipper.raiseAmounts.toString(),
                  ),
                ),
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
