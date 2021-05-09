import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_biasansor/model/blog.dart';
import 'package:flutter_biasansor/model/campaign.dart';
import 'package:flutter_biasansor/model/comment.dart';
import 'package:flutter_biasansor/model/finished_shipping.dart';
import 'package:flutter_biasansor/model/membership_form.dart';
import 'package:flutter_biasansor/model/order.dart';
import 'package:flutter_biasansor/model/rating.dart';
import 'package:flutter_biasansor/model/shipper.dart';
import 'package:flutter_biasansor/model/shipper_mini.dart';
import 'package:flutter_biasansor/model/useracc.dart';
import 'package:flutter_biasansor/services/database_base.dart';

class FirestoreDatabaseService implements DBBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> finishedWorksDocList = [];
  List<DocumentSnapshot> finishedWorksDocForAdminList = [];
  List<DocumentSnapshot> membershipFormsDocList = [];
  List<DocumentSnapshot> blogsDocList = [];
  List<DocumentSnapshot> campaignsDocList = [];
  // var finishedShippingList = <FinishedShipping>[];
  @override
  Future<UserAcc> readUser(String id) async {
    var _readedUser = await _firestore.collection('users').doc(id).get();

    var user = UserAcc.fromMap(_readedUser.data());

    return user;
  }

  @override
  Future<bool> saveUser(UserAcc userAcc) async {
    var snaphot =
        await FirebaseFirestore.instance.doc('users/${userAcc.userID}').get();
    if (snaphot.data() == null) {
      await _firestore
          .collection('users')
          .doc(userAcc.userID)
          .set(userAcc.toMap());

      return true;
    } else {
      return true;
    }
  }

  @override
  Future<bool> updateUserLocation(String userID, String newAdress) async {
    await _firestore
        .collection('users')
        .doc(userID)
        .update({'location': newAdress});
    return true;
  }

  @override
  Future<bool> updateUserName(String id, String newUserName) async {
    var firebaseUsers = await _firestore
        .collection('users')
        .where('userName', isEqualTo: newUserName)
        .get();
    if (firebaseUsers.docs.isNotEmpty) {
      return false;
    } else {
      await _firestore
          .collection('users')
          .doc(id)
          .update({'userName': newUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String id, String profilePhotoUrl) async {
    await _firestore
        .collection('users')
        .doc(id)
        .update({'profileUrl': profilePhotoUrl});
    return true;
  }

  @override
  Future<bool> updatePhoneNumber(String id, String phoneNumber) async {
    var firebaseUsers = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();
    if (firebaseUsers.docs.isNotEmpty) {
      print('Bu numara zaten mevcut firebasedatabaseservice');
      return false;
    } else {
      await _firestore
          .collection('users')
          .doc(id)
          .update({'phoneNumber': phoneNumber});
      print('güncelleme işlemi tamamlandı firebasedatabaseservice');
      return true;
    }
  }

  @override
  Future<List<String>> getAllLocations() async {
    var allLocationsList = <String>[];
    var allLocations =
        await _firestore.collection('locations').doc('allLocations').get();
    var liste = allLocations.data();
    var list = List.from(liste['shipperLocations']);
    list.forEach((element) {
      allLocationsList.add(element);
    });
    return allLocationsList;
  }

  @override
  Future<List<ShipperMini>> getAvailableShippersAscending(Order order) async {
    // print('adres : ' +
    //     order.address +
    //     ' sayı : ' +
    //     order.transportationCount.toString() +
    //     ' zaman : ' +
    //     order.dateAndTime.toString() +
    //     ' taşınacak katlar : ' +
    //     order.floorsToTransport.toString());
    //iki tane sorgu yapacaksak bu şekilde kullan örnek : locationu sivas olan ve ismi deneme olan asansörler gelsin
    //ama bizim çalışma mantığımız şu şekilde : kullanıcının belirlediği şehirdeki tüm asansörler gelir, bir listeye aktarılır
    //sonra bu elemanların hepsinin teker teker verilen tarih saat aralığında işi var mı bakılır(reservedshipping alanının içinde)
    //müsait olanlar başka bir listeye çekilir ve döndürülür. taşınacak kat sayısına göre fiyat belirlenir ve taşınacak katlara göre zam yapılır.
    //daha sonra kullanıcıya bu veriler döndürülür. easy amk
    //var availableShippers = await _firestore
    //         .collection('shippers')
    //         .where('location', isEqualTo: 'Ankara')
    //         .where('name', isEqualTo: 'Deneme')
    //         .get();
    //---------------------------------------------------------------
    var shippers = <ShipperMini>[];
    var availableShippers = await _firestore
        .collection('shippersMini')
        .where('locations', arrayContains: order.address)
        .orderBy('shippingPrice', descending: false)
        .get();

    for (QueryDocumentSnapshot doc in availableShippers.docs) {
      var shipperMini = ShipperMini.fromMap(doc.data());
      order.floorsToTransport.forEach((floor) {
        if (shipperMini.maxFloor < floor) {
          if (shippers.contains(shipperMini)) {
            shippers.remove(shipperMini);
          }
        } else {
          if (!shippers.contains(shipperMini)) {
            shippers.add(shipperMini);
          }
        }
      });
    }
    await calculateRating(shippers);
    calculatePrice(shippers, order);

    return shippers;
  }

  @override
  Future<List<ShipperMini>> getAvailableShippersDescending(Order order) async {
    var shippers = <ShipperMini>[];
    var availableShippers = await _firestore
        .collection('shippersMini')
        .where('locations', arrayContains: order.address)
        .orderBy('shippingPrice', descending: true)
        .get();

    for (QueryDocumentSnapshot doc in availableShippers.docs) {
      var shipperMini = ShipperMini.fromMap(doc.data());
      order.floorsToTransport.forEach((floor) {
        if (shipperMini.maxFloor < floor) {
          if (shippers.contains(shipperMini)) {
            shippers.remove(shipperMini);
          }
        } else {
          if (!shippers.contains(shipperMini)) {
            shippers.add(shipperMini);
          }
        }
      });
    }

    await calculateRating(shippers);
    calculatePrice(shippers, order);
    return shippers;
  }

  @override
  Future<bool> addShipperToDatabase(Shipper shipper) async {
    var ref = _firestore.collection('shippers').doc();
    var ref2 = _firestore.collection('shippersMini').doc(ref.id);

    var shipperMini = ShipperMini(
        raiseAmounts: shipper.raiseAmounts,
        exceptionFloors: shipper.exceptionFloors,
        locations: shipper.locations,
        shippingPrice: shipper.shippingPrice,
        name: shipper.name,
        shippingVehiclePhotoUrl: shipper.shippingVehiclePhotoUrl,
        maxFloor: shipper.maxFloor,
        workExperience: shipper.workExperience,
        secondShippingDiscount: shipper.secondShippingDiscount,
        id: ref.id);
    var shipperFull = Shipper(
      aboutUsText: shipper.aboutUsText,
      phoneNumber: shipper.phoneNumber,
      exceptionFloors: shipper.exceptionFloors,
      raiseAmounts: shipper.raiseAmounts,
      locations: shipper.locations,
      fullName: shipper.fullName,
      shippingPrice: shipper.shippingPrice,
      name: shipper.name,
      shippingVehiclePhotoUrl: shipper.shippingVehiclePhotoUrl,
      maxFloor: shipper.maxFloor,
      workExperience: shipper.workExperience,
      secondShippingDiscount: shipper.secondShippingDiscount,
      id: ref.id,
    );
    await ref.set(shipperFull.toMap());
    await ref2.set(shipperMini.toMap());
    return true;
  }

  @override
  Future<Shipper> getShipperDetails(String id) async {
    var rating = 0.0;

    var result = await _firestore.collection('shippers').doc(id).get();

    var shipper = Shipper.fromMap(result.data());
    var comments = await getComments(shipper.id);

    for (var rtng in comments) {
      rating += rtng.rating;
    }

    rating = rating / comments.length;
    shipper.comments = comments;
    shipper.rating = rating;
    return shipper;
  }

  @override
  Future<bool> addComment(Shipper shipper, Comment comment, Rating rating,
      String finishedShippingID) async {
    var commentsRef = _firestore.collection('comments').doc();
    var ratingsRef = _firestore.collection('ratings').doc(commentsRef.id);

    await commentsRef.set(comment.toMap());
    await ratingsRef.set(rating.toMap());
    await _firestore
        .collection('reservations')
        .doc(finishedShippingID)
        .update({'isCommented': true});
    return true;
  }

  @override
  Future<List<Rating>> getRatings(String shipperID) async {
    var list = <Rating>[];
    var snapshot = await _firestore
        .collection('ratings')
        .where('shipperID', isEqualTo: shipperID)
        .get();
    snapshot.docs.forEach((element) {
      var rating = element.data();
      list.add(Rating.fromMap(rating));
    });
    return list;
  }

  @override
  Future<List<Comment>> getComments(String shipperID) async {
    var commentList = <Comment>[];
    var snapshot = await _firestore
        .collection('comments')
        .where('commentedShipperID', isEqualTo: shipperID)
        .orderBy('commentDate', descending: true)
        .get();
    snapshot.docs.forEach((element) {
      var commentMap = element.data();
      commentList.add(Comment.fromMap(commentMap));
    });
    return commentList;
  }

  @override
  Future<bool> addFinishedShipping(FinishedShipping finishedShipping) async {
    await _firestore.collection('reservations').add(finishedShipping.toMap());
    // var shippingRef = _firestore
    //     .collection('shippings')
    //     .doc(finishedShipping.shipperID + '-' + finishedShipping.userID);
    // await shippingRef.set(finishedShipping.toMap());
    return true;
  }

  Future calculateRating(List<ShipperMini> shippers) async {
    for (var shipperMini in shippers) {
      var ratings = await getRatings(shipperMini.id);
      var rating = 0.0;
      ratings.forEach((element) {
        rating += element.rating;
      });
      if (rating != 0) {
        rating = rating / ratings.length;
      }
      shipperMini.rating = rating;
    }
  }

  void calculatePrice(List<ShipperMini> shippers, Order order) {
    var price;
    var zam;
    var lastPrice;
    var counter;
    for (var shipper in shippers) {
      var shippingPrice = shipper.shippingPrice;
      zam = 0;
      price = shippingPrice;
      lastPrice = 0;
      counter = 0;
      zam = 0;
      for (var tasinacakKat in order.floorsToTransport) {
        counter = 0;
        for (var exception in shipper.exceptionFloors) {
          if (tasinacakKat <= exception) {
          } else {
            counter++;
          }
        }
        if (counter != 0) {
          if (counter > shipper.raiseAmounts.length) {
            zam = shipper.raiseAmounts.last;
          } else {
            zam = shipper.raiseAmounts[counter - 1];
          }
        } else {
          zam = 0;
        }

        lastPrice += price + zam;
      }
      shipper.displayingShippingPrice = lastPrice;
      shipper.displayingShippingPrice -=
          (order.transportationCount / 2).floor() *
              shipper.secondShippingDiscount;
    }
  }

  // Future<List<Shipper>> getAvailableShippersAscendingWithPagination(
  //     Order order, List<Shipper> shippers) async {
  //   var availableShippers = await _firestore
  //       .collection('shippers')
  //       .where('location', isEqualTo: '${order.address}')
  //       .orderBy('shippingPrice', descending: false)
  //       .startAfterDocument(ascendingDocList[ascendingDocList.length - 1])
  //       .limit(3)
  //       .get();
  //   ascendingDocList.addAll(availableShippers.docs);
  //   availableShippers.docs.forEach((element) {
  //     var shipper = Shipper.fromMap(element.data());
  //     shippers.add(shipper);
  //   });
  //   print('buraya girdik desc pagination');
  //   return shippers;
  // }
  @override
  Future<List<FinishedShipping>> getFinishedShippings(String userID) async {
    var finishedShippingList = <FinishedShipping>[];
    var result = await _firestore
        .collection('reservations')
        .where('userID', isEqualTo: userID)
        .where('shippingDate',
            isLessThan: Timestamp.fromDate(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)))
        .where('isCommented', isEqualTo: false)
        .orderBy('shippingDate', descending: true)
        .limit(5)
        .get();
    finishedWorksDocList = result.docs;
    // print('Resultumuz : ' +
    //     result.docs.toString() +
    //     ' uzunluğu : ' +
    //     result.size.toString());
    for (var element in result.docs) {
      var finishedShipping = FinishedShipping.fromMap(element.data());
      finishedShipping.reservationID = element.id;
      finishedShippingList.add(finishedShipping);
    }

    return finishedShippingList;
  }

  @override
  Future<List<FinishedShipping>> getFinishedShippingsWithPagination(
      String userID) async {
    print('Buraya girdik');
    var finishedShippingList = <FinishedShipping>[];
    var finishedWorksDocs = await _firestore
        .collection('reservations')
        .where('userID', isEqualTo: userID)
        .where('shippingDate',
            isLessThan: Timestamp.fromDate(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)))
        .where('isCommented', isEqualTo: false)
        .orderBy('shippingDate', descending: true)
        .startAfterDocument(
            finishedWorksDocList[finishedWorksDocList.length - 1])
        .limit(5)
        .get();
    finishedWorksDocList.addAll(finishedWorksDocs.docs);
    finishedWorksDocs.docs.forEach((element) {
      var finishedShipping = FinishedShipping.fromMap(element.data());
      finishedShipping.reservationID = element.id;
      finishedShippingList.add(finishedShipping);
    });
    // print('Resultumuz : ' +
    //     result.docs.toString() +
    //     ' uzunluğu : ' +
    //     result.size.toString());
    // for (var element in result.docs) {
    //
    // }

    return finishedShippingList;
  }

  @override
  Future<List<FinishedShipping>> getAllFinishedShippingsForAdmin() async {
    var finishedShippingListForAdmins = <FinishedShipping>[];
    var result = await _firestore
        .collection('reservations')
        .orderBy('shippingDate', descending: true)
        .limit(5)
        .get();
    finishedWorksDocForAdminList = result.docs;
    for (var element in result.docs) {
      var finishedShipping = FinishedShipping.fromMap(element.data());
      finishedShipping.reservationID = element.id;
      finishedShippingListForAdmins.add(finishedShipping);
    }

    return finishedShippingListForAdmins;
  }

  @override
  Future<List<FinishedShipping>>
      getAllFinishedShippingsForAdminWithPagination() async {
    print('Buraya girdik');
    var finishedShippingListForAdmins = <FinishedShipping>[];
    var finishedWorksDocsForAdmins = await _firestore
        .collection('reservations')
        .orderBy('shippingDate', descending: true)
        .startAfterDocument(finishedWorksDocForAdminList[
            finishedWorksDocForAdminList.length - 1])
        .limit(5)
        .get();
    finishedWorksDocForAdminList.addAll(finishedWorksDocsForAdmins.docs);
    finishedWorksDocsForAdmins.docs.forEach((element) {
      var finishedShipping = FinishedShipping.fromMap(element.data());
      finishedShipping.reservationID = element.id;
      finishedShippingListForAdmins.add(finishedShipping);
    });
    // print('Resultumuz : ' +
    //     result.docs.toString() +
    //     ' uzunluğu : ' +
    //     result.size.toString());
    // for (var element in result.docs) {
    //
    // }

    return finishedShippingListForAdmins;
  }

  @override
  Future<bool> addMembershipFormToDatabase(
      MembershipForm membershipForm) async {
    await _firestore.collection('membershipForms').add(membershipForm.toMap());
    return true;
  }

  @override
  Future<List<MembershipForm>> getMembershipForms() async {
    var membershipForms = <MembershipForm>[];
    var result = await _firestore
        .collection('membershipForms')
        .orderBy("formSendingDate", descending: true)
        .limit(5)
        .get();
    membershipFormsDocList = result.docs;
    for (var element in result.docs) {
      var membershipForm = MembershipForm.fromMap(element.data());
      membershipForms.add(membershipForm);
    }

    return membershipForms;
  }

  @override
  Future<List<MembershipForm>> getMembershipFormsWithPagination() async {
    print('Buraya girdik');
    var membershipFormList = <MembershipForm>[];
    var membershipDocs = await _firestore
        .collection('membershipForms')
        .orderBy("formSendingDate", descending: true)
        .startAfterDocument(
            membershipFormsDocList[membershipFormsDocList.length - 1])
        .limit(5)
        .get();
    membershipFormsDocList.addAll(membershipDocs.docs);
    membershipDocs.docs.forEach((element) {
      var membershipForm = MembershipForm.fromMap(element.data());
      membershipFormList.add(membershipForm);
    });
    return membershipFormList;
  }

  //önce addblog sonra addblogphoto
  @override
  Future<String> addBlog(Blog blog) async {
    var blogRef = _firestore.collection("blogs").doc();
    blog.blogID = blogRef.id;
    blog.blogTime = Timestamp.now();
    await blogRef.set(blog.toMap());
    return blogRef.id;
  }

  //TODO BU EKLENECEK
  Future<String> addCampaign(Campaign campaign) async {
    var campaignRef = _firestore.collection("campaigns").doc();
    campaign.campaignID = campaignRef.id;
    campaign.campaignDate = Timestamp.now();
    await campaignRef.set(campaign.toMap());
    return campaignRef.id;
  }

  Future<List<Blog>> readBlogs() async {
    var blogs = <Blog>[];
    var result = await _firestore
        .collection("blogs")
        .orderBy("blogTime", descending: true)
        .limit(10)
        .get();
    blogsDocList = result.docs;
    for (var blogDoc in result.docs) {
      //id ile bloglardan fotoları oku indirme linkine eşitle blog nesnesi oluştur listeye ekle listeyi döndür
      var blog = Blog.fromMap(blogDoc.data());
      blogs.add(blog);
    }
    return blogs;
  }

  @override
  Future<List<Blog>> readBlogsWithPagination() async {
    var blogs = <Blog>[];
    var result = await _firestore
        .collection("blogs")
        .orderBy("blogTime", descending: true)
        .startAfterDocument(blogsDocList[blogsDocList.length - 1])
        .limit(10)
        .get();
    blogsDocList.addAll(result.docs);
    for (var blogDoc in result.docs) {
      //id ile bloglardan fotoları oku indirme linkine eşitle blog nesnesi oluştur listeye ekle listeyi döndür
      var blog = Blog.fromMap(blogDoc.data());
      blogs.add(blog);
    }
    return blogs;
  }

  @override
  Future<List<Campaign>> getCampaigns() async {
    var campaigns = <Campaign>[];
    var result = await _firestore
        .collection("campaigns")
        .orderBy("campaignDate", descending: true)
        .limit(10)
        .get();
    campaignsDocList = result.docs;
    for (var campaignDoc in result.docs) {
      var campaign = Campaign.fromMap(campaignDoc.data());
      //bura çalışıyor
      // print(campaign.toString());
      campaigns.add(campaign);
    }
    return campaigns;
  }

  @override
  Future<List<Campaign>> getCampaignsWithPagination() async {
    var campaigns = <Campaign>[];
    var result = await _firestore
        .collection("campaigns")
        .orderBy("campaignDate", descending: true)
        .startAfterDocument(campaignsDocList[campaignsDocList.length - 1])
        .limit(10)
        .get();
    campaignsDocList.addAll(result.docs);
    for (var campaignDoc in result.docs) {
      var campaign = Campaign.fromMap(campaignDoc.data());
      campaigns.add(campaign);
    }
    return campaigns;
  }
}
