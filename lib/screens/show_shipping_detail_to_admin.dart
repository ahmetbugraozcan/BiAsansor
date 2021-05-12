import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/locator.dart';
import 'package:flutter_biasansor/model/finished_shipping.dart';
import 'package:flutter_biasansor/model/useracc.dart';
import 'package:flutter_biasansor/services/firestore_database_service.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:provider/provider.dart';

class ShowShippingDetailToAdmin extends StatefulWidget {
  String userID;
  FinishedShipping finishedShipping;
  ShowShippingDetailToAdmin(this.userID, this.finishedShipping);
  @override
  _ShowShippingDetailToAdminState createState() =>
      _ShowShippingDetailToAdminState();
}

class _ShowShippingDetailToAdminState extends State<ShowShippingDetailToAdmin> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    // var _viewModel = Provider.of<ViewModel>(context);
    final _firestoreDatabaseService = locator<FirestoreDatabaseService>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Kiralama Bilgileri"),
      ),
      body: FutureBuilder(
        future: _firestoreDatabaseService.readUser(widget.userID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            UserAcc _user = snapshot.data;
            return Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: Row(
                      children: [
                        Spacer(),
                        Expanded(
                          flex: 10,
                          child: buildUserAvatar(context, _user),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 20,
                          child: buildUserNameText(_user, context),
                        ),
                        Spacer()
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 22,
                    child: Card(
                      elevation: 20,
                      child: ListView(
                        children: [
                          buildKullaniciAdiListTile(_user),
                          buildEmailListTile(_user),
                          buildKonumListTile(_user),
                          buildPhoneNumberListTile(_user),
                          buildShippingPhoneNumberListTile(
                              widget.finishedShipping),
                          buildShippingIDListTile(widget.finishedShipping),
                          buildAdresListTile(widget.finishedShipping),
                          buildTransportCountListTile(widget.finishedShipping),
                          buildFloorsToTransportListTile(
                              widget.finishedShipping),
                          buildPriceListTile(widget.finishedShipping),
                          buildAdressesListTile(widget.finishedShipping),
                          // widget.finishedShipping.location, widget.finishedShipping.transportCount, widget.finishedShipping.transportedFloors,
                        ],
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  ListTile buildKullaniciAdiListTile(UserAcc _user) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text('Kullanıcı Adı'),
      subtitle: Text(_user.userName),
    );
  }

  ListTile buildEmailListTile(UserAcc _user) {
    return ListTile(
      title: Text("E-posta"),
      leading: Icon(Icons.mail),
      subtitle: Text(_user.email),
    );
  }

  ListTile buildPriceListTile(FinishedShipping finishedShipping) {
    return ListTile(
      title: Text("Kiralama Ücreti"),
      leading: Icon(Icons.money),
      subtitle: Text(finishedShipping.price.toString() + " TL"),
    );
  }

  ListTile buildPhoneNumberListTile(UserAcc _user) {
    return ListTile(
      leading: Icon(Icons.phone),
      title: Text('Telefon Numarası'),
      subtitle: Text(_user.phoneNumber),
    );
  }

  ListTile buildShippingPhoneNumberListTile(FinishedShipping finishedShipping) {
    return ListTile(
      leading: Icon(Icons.phone),
      title: Text('Kiralama Telefon Numarası'),
      subtitle: Text(finishedShipping.phoneNumber),
    );
  }

  ListTile buildShippingIDListTile(FinishedShipping finishedShipping) {
    return ListTile(
      leading: Icon(Icons.notification_important),
      title: Text('Kiralama IDsi'),
      subtitle: Text(finishedShipping.reservationID),
    );
  }

  ListTile buildKonumListTile(UserAcc _user) {
    return ListTile(
      leading: Icon(Icons.location_on),
      title: Text('Kullanıcı Konum'),
      subtitle: Text(_user.location),
    );
  }

  ListTile buildTransportCountListTile(FinishedShipping finishedShipping) {
    return ListTile(
      leading: Icon(Icons.map),
      title: Text('Taşıma Sayısı'),
      subtitle: Text(
        finishedShipping.transportCount.toString(),
      ),
    );
  }

  ListTile buildFloorsToTransportListTile(FinishedShipping finishedShipping) {
    return ListTile(
      leading: Icon(Icons.format_list_numbered_outlined),
      title: Text('Taşınacak Katlar'),
      subtitle: Text(
        finishedShipping.transportedFloors.toString(),
      ),
    );
  }

  ListTile buildAdresListTile(FinishedShipping finishedShipping) {
    return ListTile(
      leading: Icon(Icons.map),
      title: Text('Kiralama Adresi'),
      subtitle: Text(finishedShipping.location),
    );
  }

  ListTile buildAdressesListTile(FinishedShipping finishedShipping) {
    return ListTile(
      leading: Icon(Icons.map),
      title: Text('Taşınacak Adresler'),
      subtitle: Text(finishedShipping.locationsToTransport),
    );
  }

  Widget buildUserAvatar(BuildContext context, UserAcc _user) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(300),
        child: Image.network(_user.profileUrl, fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        }),
      ),
    );
  }

  Widget buildUserNameText(UserAcc _user, BuildContext context) {
    return Text('Ad Soyad: ' + _user.fullName,
        style: context.theme.textTheme.headline6
            .copyWith(fontWeight: FontWeight.w400));
  }
}
