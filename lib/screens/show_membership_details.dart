import 'package:flutter/material.dart';
import 'package:flutter_biasansor/core/extensions/context_extension.dart';
import 'package:flutter_biasansor/locator.dart';
import 'package:flutter_biasansor/model/membership_form.dart';
import 'package:flutter_biasansor/utils.dart';

class ShowMembershipDetails extends StatefulWidget {
  MembershipForm membershipForm;
  ShowMembershipDetails({@required this.membershipForm});
  @override
  _ShowMembershipDetailsState createState() => _ShowMembershipDetailsState();
}

class _ShowMembershipDetailsState extends State<ShowMembershipDetails> {
  @override
  Widget build(BuildContext context) {
    var membershipForm = widget.membershipForm;
    var _utils = locator<Utils>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Başvuru Formu Detayları"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Başvuranın adı",
                style: context.theme.textTheme.headline6
                    .copyWith(color: Colors.blue[900])),
            subtitle: TextFormField(
              readOnly: true,
              initialValue: membershipForm.fullName,
            ),
          ),
          ListTile(
            title: Text("Başvuranın Şirket Adı",
                style: context.theme.textTheme.headline6
                    .copyWith(color: Colors.blue[900])),
            subtitle: TextFormField(
              readOnly: true,
              initialValue: membershipForm.shippingName,
            ),
          ),
          ListTile(
            title: Text("Başvuranın Telefon Numarası",
                style: context.theme.textTheme.headline6
                    .copyWith(color: Colors.blue[900])),
            subtitle: TextFormField(
              readOnly: true,
              initialValue: membershipForm.phoneNumber,
            ),
          ),
          ListTile(
            title: Text("Başvuranın Çalıştığı Bölgeler",
                style: context.theme.textTheme.headline6
                    .copyWith(color: Colors.blue[900])),
            subtitle: TextFormField(
              readOnly: true,
              initialValue: membershipForm.locations.toString(),
            ),
          ),
          ListTile(
            title: Text("Başvuranın Sektördeki Deneyimi",
                style: context.theme.textTheme.headline6
                    .copyWith(color: Colors.blue[900])),
            subtitle: TextFormField(
              readOnly: true,
              initialValue: membershipForm.experience.toString() + " Yıl",
            ),
          ),
          ListTile(
            title: Text("Başvuranın Asansör Fotoğraf Urli",
                style: context.theme.textTheme.headline6
                    .copyWith(color: Colors.blue[900])),
            subtitle: TextFormField(
              readOnly: true,
              initialValue: membershipForm.photoUrl,
            ),
          ),
          ListTile(
            title: Text("Başvuranın Şirketi Hakkında Bilgiler",
                style: context.theme.textTheme.headline6
                    .copyWith(color: Colors.blue[900])),
            subtitle: TextFormField(
              readOnly: true,
              initialValue: membershipForm.aboutUs,
            ),
          ),
          ListTile(
            title: Text("Kat Tarifeleri",
                style: context.theme.textTheme.headline6
                    .copyWith(color: Colors.blue[900])),
            subtitle: TextFormField(
              readOnly: true,
              initialValue: membershipForm.floorPrices,
            ),
          ),
          ListTile(
            title: Text("Çıkabileceği En Yüksek Kat Sayısı",
                style: context.theme.textTheme.headline6
                    .copyWith(color: Colors.blue[900])),
            subtitle: TextFormField(
              readOnly: true,
              initialValue: membershipForm.maxFloor.toString(),
            ),
          ),
          ListTile(
            title: Text("Formun Gönderildiği Tarih",
                style: context.theme.textTheme.headline6
                    .copyWith(color: Colors.blue[900])),
            subtitle: TextFormField(
              readOnly: true,
              initialValue:
                  _utils.printDate(membershipForm.formSendingDate.toDate()),
            ),
          ),
        ],
      ),
    );
  }
}
