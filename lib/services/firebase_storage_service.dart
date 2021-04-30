import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_biasansor/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference _storageReference;
  @override
  Future<String> uploadFile(
      String userID, String fileType, File yuklenecekDosya) async {
    var url;
    _storageReference = _firebaseStorage
        .ref()
        .child(userID)
        .child(fileType)
        .child('profile_photo.png');
    var uploadTask = _storageReference.putFile(yuklenecekDosya);
    await uploadTask.whenComplete(() {
      url = uploadTask.snapshot.ref.getDownloadURL();
    });
    return url;
  }

  Future<String> uploadBlogImage(String blogID, File blogPhoto) async {
    try {
      var url;
      // var _reference =
      _storageReference =
          _firebaseStorage.ref().child('blogPhoto').child(blogID).child(blogID);
      var uploadTask = _storageReference.putFile(blogPhoto);
      await uploadTask.whenComplete(() {
        return url;
      });

      // ignore: empty_catches
    } catch (ex) {}
  }

  @override
  Future<String> getBlogPhotoDownloadLink(String id) async {
    var url;
    try {
      url = await _firebaseStorage
          .ref()
          .child('blogPhoto')
          .child(id)
          .child(id)
          .getDownloadURL();
      return url;
    } catch (ex) {
      debugPrint("Link alınamadı : " + ex.toString());
    }
  }
}
