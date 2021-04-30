import 'package:flutter/material.dart';
import 'package:flutter_biasansor/model/membership_form.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Başvuru Formu Detayları"),
      ),
      body: ListView(
        children: [
          Text(membershipForm.floorPrices ?? " null"),
          Text("Başvuranın Adı : " + membershipForm.fullName),
          Text("Başvuranın Şirket Adı : " + membershipForm.shippingName),
          Text("Başvuranın Telefon Numarası: " + membershipForm.phoneNumber),
          // Text("Başvuranın Fiyatlandırma Tarifesi : " +
          //     membershipForm.floorPrices),
          Text("Başvuranın Çalıştığı Bölgeler: " +
              membershipForm.locations.toString()),
          Text("Başvuranın Sektördeki Deneyimi: " +
              membershipForm.experience.toString() +
              " Yıl"),
          Text("Başvuranın Asansör Fotoğraf Urli: " + membershipForm.photoUrl),
          Text("Başvuranın Asansörünün Çıkabileceği En Yüksek Kat Sayısı " +
              membershipForm.maxFloor.toString() +
              " Kat"),
          Text("Başvuranın Şirketi Hakkında Bilgiler" + membershipForm.aboutUs),
        ],
      ),
    );
  }
}
