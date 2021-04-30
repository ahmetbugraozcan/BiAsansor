import 'package:flutter_biasansor/model/finished_shipping.dart';
import 'package:flutter_biasansor/model/membership_form.dart';
import 'package:flutter_biasansor/model/shipper.dart';
import 'package:flutter_biasansor/model/useracc.dart';
import 'package:flutter_biasansor/utils.dart';
import 'package:http/http.dart' as http;

class NotificationSenderService {
  Future<bool> sendMembershipFormNotification(
      MembershipForm membershipForm) async {
    var headers = <String, String>{
      'Content-type': 'application/json',
      'Authorization': 'key=${Utils.FCMApiAuthKey}'
    };
    //TODO PAYLOAD MAP OLSUN ALANLARI KULLANILACAK
    // membershipForm.photoUrl,membershipForm.aboutUs, membershipForm.experience,
    // membershipForm.floorPrices,membershipForm.locations, membershipForm.maxFloor,

    var payload =
        "Başvuran adı : ${membershipForm.fullName} \n\nAsansör Adı : ${membershipForm.shippingName} \n\nTelefon Numarası : ${membershipForm.phoneNumber}\n\nFotoğraf url : ${membershipForm.photoUrl}\n\nKat Tarifeleri : ${membershipForm.floorPrices}\n\nHakkımızda metni : ${membershipForm.aboutUs}\n\nSektördeki Tecrübesi : ${membershipForm.experience}\n\nÇalıştığı Bölgeler : ${membershipForm.locations}\n\nÇıkabildiği en yüksek kat : ${membershipForm.maxFloor}";
    //PAYLOADI datalara bölsek güzel olabilir aslında ama şu an uğraşmayalım
    var json =
        '{ "to" : "/topics/admin", "data" : { "message" : "Bir kullanıcı başvuru formu yolladı.", "title": "Başvuru Formu", "payload": "$payload"} }';

    var response = await http.post(Uri.parse(Utils.FCMApiEndUrl),
        headers: headers, body: json);

    if (response.statusCode == 200) {
      print('işlem basarılı');
    } else {
      print("işlem basarısız:" + response.statusCode.toString());
      print("jsonumuz:" + json);
    }
  }

  Future<bool> sendFinishedShippingNotification(
      FinishedShipping shipping, UserAcc userAcc, Shipper shipper) async {
    var headers = <String, String>{
      'Content-type': 'application/json',
      'Authorization': 'key=${Utils.FCMApiAuthKey}'
    };
    //TODO PAYLOAD MAP OLSUN ALANLARI KULLANILACAK
    var payload =
        "Kiralanan iş : ${shipping.shipperName} \n\nKiralama Tarihi : ${shipping.shippingDate.toDate()} \n\nAsansörcü ID : ${shipper.id} \n\nAsansörcü Telefon Numarası : ${shipper.phoneNumber} \n\nKiralanan Şehir: ${shipping.location} \n\nKiralama Ücreti : ${shipper.displayingShippingPrice}TL\n\n ---------------------------------\n\nKiralayan kullanıcı: ${userAcc.userName} \n\nKiralayan Kişi Tam Adı : ${userAcc.fullName} \n\nKiralayan Kişi Telefon Numarası : ${userAcc.phoneNumber} \n\nKiralama Telefon Numarası : ${shipping.phoneNumber}\n\nKiralayan Kullanıcı ID : ${userAcc.userID}\n\nKullanıcı Email : ${userAcc.email}";
    //PAYLOADI datalara bölsek güzel olabilir aslında ama şu an uğraşmayalım
    var json =
        '{ "to" : "/topics/admin", "data" : { "message" : "Bir kullanıcı kiralama işlemini tamamladı.", "title": "Kiralama İşlemi", "payload": "$payload"} }';

    var response = await http.post(Uri.parse(Utils.FCMApiEndUrl),
        headers: headers, body: json);

    if (response.statusCode == 200) {
      print('işlem basarılı');
    } else {
      print("işlem basarısız:" + response.statusCode.toString());
      print("jsonumuz:" + json);
    }
  }
}
