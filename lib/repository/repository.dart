import 'dart:io';

import 'package:flutter_biasansor/locator.dart';
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
import 'package:flutter_biasansor/services/auth_base.dart';
import 'package:flutter_biasansor/services/fake_auth_service.dart';
import 'package:flutter_biasansor/services/firebase_auth_service.dart';
import 'package:flutter_biasansor/services/firebase_storage_service.dart';
import 'package:flutter_biasansor/services/firestore_database_service.dart';
import 'package:flutter_biasansor/services/notification_sender_service.dart';

enum AppMode { DEBUG, RELEASE }

//email girişte hata var düzeltelim
class Repository implements AuthBase {
  AppMode appMode = AppMode.RELEASE;
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FakeAuthenticationService _fakeAuthenticationService =
      locator<FakeAuthenticationService>();
  final FirestoreDatabaseService _firestoreDatabaseService =
      locator<FirestoreDatabaseService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();
  final NotificationSenderService _notificationSenderService =
      locator<NotificationSenderService>();
  @override
  Future<UserAcc> createUserWithEmailAndPassword(
      String email, String sifre, String fullName) async {
    if (appMode == AppMode.RELEASE) {
      var _userAcc = await _firebaseAuthService.createUserWithEmailAndPassword(
          email, sifre, fullName);
      // _userAcc.fullName = fullName;
      var sonuc = await _firestoreDatabaseService.saveUser(_userAcc);
      if (sonuc) {
        return await _firestoreDatabaseService.readUser(_userAcc.userID);
      } else {
        print("repo firestoresaveuser hata");
        return null;
      }
    } else {
      return await _fakeAuthenticationService.createUserWithEmailAndPassword(
          email, sifre, fullName);
    }
  }

  @override
  Future<UserAcc> currentUser() async {
    if (appMode == AppMode.RELEASE) {
      var _userAcc = await _firebaseAuthService.currentUser();
      if (_userAcc != null) {
        return await _firestoreDatabaseService.readUser(_userAcc.userID);
      } else {
        return null;
      }
    } else {
      return await _fakeAuthenticationService.currentUser();
    }
  }

  @override
  Future<UserAcc> signInWithEmailAndPassword(String email, String sifre) async {
    if (appMode == AppMode.RELEASE) {
      var _userAcc =
          await _firebaseAuthService.signInWithEmailAndPassword(email, sifre);
      return await _firestoreDatabaseService.readUser(_userAcc.userID);
    } else {
      return await _fakeAuthenticationService.signInWithEmailAndPassword(
          email, sifre);
    }
  }

  @override
  Future<UserAcc> signInWithFacebook() async {
    if (appMode == AppMode.RELEASE) {
      var _userAcc = await _firebaseAuthService.signInWithFacebook();
      if (_userAcc != null) {
        var _sonuc = await _firestoreDatabaseService.saveUser(_userAcc);
        if (_sonuc) {
          return await _firestoreDatabaseService.readUser(_userAcc.userID);
        } else {
          await _firebaseAuthService.signOut();
          return null;
        }
      } else {
        return null;
      }
    } else {
      var _userAcc = await _fakeAuthenticationService.signInWithFacebook();
      return _userAcc;
    }
  }

  @override
  Future<UserAcc> signInWithGoogle() async {
    if (appMode == AppMode.RELEASE) {
      var _userAcc = await _firebaseAuthService.signInWithGoogle();
      if (_userAcc != null) {
        var _sonuc = await _firestoreDatabaseService.saveUser(_userAcc);
        if (_sonuc) {
          return await _firestoreDatabaseService.readUser(_userAcc.userID);
        } else {
          await _firebaseAuthService.signOut();
          return null;
        }
      } else {
        return null;
      }
    } else {
      var _userAcc = await _fakeAuthenticationService.signInWithGoogle();
      return _userAcc;
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.RELEASE) {
      var result = await _firebaseAuthService.signOut();
      return result;
    } else {
      var result = await _fakeAuthenticationService.signOut();
      return result;
    }
  }

  Future<bool> updateUserLocation(String userID, String newLocation) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return await _firestoreDatabaseService.updateUserLocation(
          userID, newLocation);
    }
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return await _firestoreDatabaseService.updateUserName(
          userID, newUserName);
    }
  }

  Future<bool> updateProfilePhoto(String userID, String newPhotoLink) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return await _firestoreDatabaseService.updateProfilePhoto(
          userID, newPhotoLink);
    }
  }

  Future<bool> updatePhoneNumber(String userID, String phoneNumber) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return await _firestoreDatabaseService.updatePhoneNumber(
          userID, phoneNumber);
    }
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilePhoto) async {
    if (appMode == AppMode.DEBUG) {
      return 'dosya_indirme_linki';
    } else {
      var profilePhotoUrl = await _firebaseStorageService.uploadFile(
          userID, fileType, profilePhoto);
      return profilePhotoUrl;
    }
  }

  @override
  Future<bool> sendEmailVerification() async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      var sonuc = await _firebaseAuthService.sendEmailVerification();
      return sonuc;
    }
  }

  Future<List<ShipperMini>> getAvailableShippersAscending(Order order) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService
          .getAvailableShippersAscending(order);
    }
  }

  Future<List<ShipperMini>> getAvailableShippersDescending(Order order) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService
          .getAvailableShippersDescending(order);
    }
  }

  Future<List<String>> getAllLocations() async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService.getAllLocations();
    }
  }

  Future<bool> addShipperToDatabase(Shipper shipper) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService.addShipperToDatabase(shipper);
    }
  }

  Future<Shipper> getShipperDetails(String id) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService.getShipperDetails(id);
    }
  }

  Future<bool> addComment(Shipper shipper, Comment comment, Rating rating,
      String finishedShippingID) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService.addComment(
          shipper, comment, rating, finishedShippingID);
    }
  }

  Future<List<Rating>> getRatings(String shipperID) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService.getRatings(shipperID);
    }
  }

  Future<bool> addFinishedShipping(FinishedShipping finishedShipping,
      UserAcc userAcc, Shipper shipper) async {
    //bildirimler burada gerçekleşecek
    if (appMode == AppMode.DEBUG) {
    } else {
      var result =
          await _firestoreDatabaseService.addFinishedShipping(finishedShipping);
      if (result) {
        await _notificationSenderService.sendFinishedShippingNotification(
            finishedShipping, userAcc, shipper);
        return true;
      } else {
        return false;
      }
    }
  }

  Future<List<FinishedShipping>> getFinishedShippings(String userID) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService.getFinishedShippings(userID);
    }
  }

  Future<List<FinishedShipping>> getFinishedShippingsWithPagination(
      String userID) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService
          .getFinishedShippingsWithPagination(userID);
    }
  }

  Future<List<FinishedShipping>> getAllFinishedShippingsForAdmin() async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService.getAllFinishedShippingsForAdmin();
    }
  }

  Future<List<FinishedShipping>>
      getAllFinishedShippingsForAdminWithPagination() async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService
          .getAllFinishedShippingsForAdminWithPagination();
    }
  }

  Future<bool> addMembershipFormToDatabase(
      MembershipForm membershipForm) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      var result = await _firestoreDatabaseService
          .addMembershipFormToDatabase(membershipForm);
      if (result) {
        await _notificationSenderService
            .sendMembershipFormNotification(membershipForm);
        return result;
      } else {
        return false;
      }
    }
  }

  Future<List<MembershipForm>> getMembershipFormsWithPagination() async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService.getMembershipFormsWithPagination();
    }
  }

  Future<List<MembershipForm>> getMembershipForms() async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService.getMembershipForms();
    }
  }

  Future<String> uploadBlogImage(String blogID, File blogPhoto) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firebaseStorageService.uploadBlogImage(blogID, blogPhoto);
    }
  }

  Future<String> uploadCampaignPhoto(
      String campaignID, File campaignPhoto) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firebaseStorageService.uploadCampaignPhoto(
          campaignID, campaignPhoto);
    }
  }

  Future<String> addBlog(Blog blog) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService.addBlog(blog);
    }
  }

  Future<String> addCampaign(Campaign campaign) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firestoreDatabaseService.addCampaign(campaign);
    }
  }

  Future<List<Blog>> readBlogsWithPagination() async {
    if (appMode == AppMode.DEBUG) {
    } else {
      var blogs = await _firestoreDatabaseService.readBlogsWithPagination();
      for (var blog in blogs) {
        var url =
            await _firebaseStorageService.getBlogPhotoDownloadLink(blog.blogID);
        blog.blogPhotoLink = url;
      }
      return blogs;
    }
  }

  Future<List<Blog>> readBlogs() async {
    if (appMode == AppMode.DEBUG) {
    } else {
      var blogs = await _firestoreDatabaseService.readBlogs();
      for (var blog in blogs) {
        var url =
            await _firebaseStorageService.getBlogPhotoDownloadLink(blog.blogID);
        blog.blogPhotoLink = url;
      }
      return blogs;
    }
  }

  Future<List<Campaign>> getCampaigns() async {
    if (appMode == AppMode.DEBUG) {
    } else {
      var campaigns = await _firestoreDatabaseService.getCampaigns();
      for (var campaign in campaigns) {
        var url = await _firebaseStorageService
            .getCampaignPhotoDownloadLink(campaign.campaignID);
        campaign.photoLink = url;
      }
      return campaigns;
    }
  }

  Future<List<Campaign>> getCampaignsWithPagination() async {
    if (appMode == AppMode.DEBUG) {
    } else {
      var campaigns =
          await _firestoreDatabaseService.getCampaignsWithPagination();
      for (var campaign in campaigns) {
        var url = await _firebaseStorageService
            .getCampaignPhotoDownloadLink(campaign.campaignID);
        campaign.photoLink = url;
      }
      return campaigns;
    }
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    if (appMode == AppMode.DEBUG) {
    } else {
      return await _firebaseAuthService.sendPasswordResetEmail(email);
    }
  }
}
