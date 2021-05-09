import 'dart:io';
import 'package:flutter/cupertino.dart';
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
import 'package:flutter_biasansor/repository/repository.dart';
import 'package:flutter_biasansor/services/auth_base.dart';

//ViewState ile oynama auth harici işlemlerde bozuyor
enum ViewState { Idle, Busy }
enum ProfileState { Idle, Busy }

class ViewModel with ChangeNotifier implements AuthBase {
  final Repository _userRepository = locator<Repository>();
  UserAcc _user;

  ViewState _state = ViewState.Idle;
  ViewState get state => _state;

  UserAcc get user => _user;
  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  ProfileState _profileState = ProfileState.Idle;
  ProfileState get profileState => _profileState;
  set profileState(ProfileState value) {
    _profileState = value;
    notifyListeners();
  }

  ViewModel() {
    currentUser();
  }
  @override
  Future<UserAcc> createUserWithEmailAndPassword(
      String email, String sifre, String fullName) async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.createUserWithEmailAndPassword(
          email, sifre, fullName);
      if (_user != null) {
        return _user;
      } else {
        print('Viewmodel createuserwithemail boş döndü');
        return null;
      }
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserAcc> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      if (_user != null) {
        return _user;
      } else {
        print('usermodel currentuser user boş döndü');
        return null;
      }
    } catch (ex) {
      print('Usermodel currentuser hata : ' + ex.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserAcc> signInWithEmailAndPassword(String email, String sifre) async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithEmailAndPassword(email, sifre);
      if (_user != null) {
        return _user;
      } else {
        print('Usermodel signinemail null döndü');
        return null;
      }
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserAcc> signInWithFacebook() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithFacebook();
      if (_user != null) {
        return _user;
      } else {
        print("UserModel facebooksignin boş döndü");
        return null;
      }
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserAcc> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      if (_user != null) {
        return _user;
      } else {
        print("usermodel googlesignin user boş döndü");
        return null;
      }
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      var result = await _userRepository.signOut();
      if (result) {
        _user = null;
        return result;
      }
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<bool> updateUserLocation(String userID, String newAddress) async {
    try {
      profileState = ProfileState.Busy;
      var sonuc = await _userRepository.updateUserLocation(userID, newAddress);
      if (sonuc) {
        _user.location = newAddress;
      }
      return sonuc;
    } finally {
      profileState = ProfileState.Idle;
    }
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    try {
      profileState = ProfileState.Busy;
      var sonuc = await _userRepository.updateUserName(userID, newUserName);
      if (sonuc) {
        _user.userName = newUserName;
      }
      return sonuc;
    } finally {
      profileState = ProfileState.Idle;
    }
  }

  Future<bool> updateProfilePhoto(String userID, String newPhoto) async {
    print("Buraya girildi");
    try {
      profileState = ProfileState.Busy;
      var _sonuc = await _userRepository.updateProfilePhoto(userID, newPhoto);
      if (_sonuc) {
        _user.profileUrl = newPhoto;
      }
      return _sonuc;
    } finally {
      profileState = ProfileState.Idle;
    }
  }

  Future<bool> updatePhoneNumber(String userID, String phoneNumber) async {
    try {
      profileState = ProfileState.Busy;
      var _sonuc = await _userRepository.updatePhoneNumber(userID, phoneNumber);
      if (_sonuc) {
        _user.phoneNumber = phoneNumber;
      }
      return _sonuc;
    } finally {
      profileState = ProfileState.Idle;
    }
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilePhoto) async {
    try {
      // profileState = ViewState2.Busy;
      var downloadURL =
          _userRepository.uploadFile(userID, fileType, profilePhoto);

      return downloadURL;
    } finally {
      // profileState = ViewState2.Idle;
    }
  }

  @override
  Future<bool> sendEmailVerification() async {
    try {
      profileState = ProfileState.Busy;
      await _userRepository.sendEmailVerification();
    } finally {
      profileState = ProfileState.Idle;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    return await _userRepository.sendPasswordResetEmail(email);
  }

  Future<List<ShipperMini>> getAvailableShippersAscending(Order order) async {
    var list = await _userRepository.getAvailableShippersAscending(order);

    return list;
  }

  Future<List<ShipperMini>> getAvailableShippersDescending(Order order) async {
    var list = await _userRepository.getAvailableShippersDescending(order);

    return list;
  }

  Future<List<String>> getAllLocations() async {
    var list = await _userRepository.getAllLocations();
    return list;
  }

  Future<bool> addShipperToDatabase(Shipper shipper) async {
    await _userRepository.addShipperToDatabase(shipper);
    return true;
  }

  Future<Shipper> getShipperDetails(String id) async {
    return await _userRepository.getShipperDetails(id);
  }

  Future<List<Rating>> getRatings(String id) async {
    return await _userRepository.getRatings(id);
  }
  // Future<List<Comment>> getComments(String id) async{
  //   return await _userRepository.getComments(id);
  // }

  Future<bool> addComment(Shipper shipper, Comment comment, Rating rating,
      String finishedShippingID) async {
    return await _userRepository.addComment(
        shipper, comment, rating, finishedShippingID);
  }

  Future<bool> addFinishedShipping(FinishedShipping finishedShipping,
      UserAcc userAcc, Shipper shipper) async {
    return await _userRepository.addFinishedShipping(
        finishedShipping, userAcc, shipper);
  }

  Future<List<FinishedShipping>> getFinishedShippings(String userID) async {
    return await _userRepository.getFinishedShippings(userID);
  }

  Future<List<FinishedShipping>> getFinishedShippingsWithPagination(
      String userID) async {
    return await _userRepository.getFinishedShippingsWithPagination(userID);
  }

  Future<List<FinishedShipping>> getAllFinishedShippingsForAdmin() async {
    return await _userRepository.getAllFinishedShippingsForAdmin();
  }

  Future<List<FinishedShipping>>
      getAllFinishedShippingsForAdminWithPagination() async {
    return await _userRepository
        .getAllFinishedShippingsForAdminWithPagination();
  }

  Future<bool> addMembershipFormToDatabase(
      MembershipForm membershipForm) async {
    return await _userRepository.addMembershipFormToDatabase(membershipForm);
  }

  Future<List<MembershipForm>> getMembershipFormsWithPagination() async {
    return await _userRepository.getMembershipFormsWithPagination();
  }

  Future<List<MembershipForm>> getMembershipForms() async {
    return await _userRepository.getMembershipForms();
  }

  Future<String> addBlog(Blog blog) async {
    return await _userRepository.addBlog(blog);
  }

  Future<String> addCampaign(Campaign campaign) async {
    return await _userRepository.addCampaign(campaign);
  }

//addCampaign
  Future<String> uploadCampaignPhoto(
      String campaignID, File campaignPhoto) async {
    return await _userRepository.uploadCampaignPhoto(campaignID, campaignPhoto);
  }

  Future<String> uploadBlogImage(String blogID, File blogPhoto) async {
    return await _userRepository.uploadBlogImage(blogID, blogPhoto);
  }

  Future<List<Blog>> readBlogsWithPagination() async {
    return await _userRepository.readBlogsWithPagination();
  }

  Future<List<Blog>> readBlogs() async {
    return await _userRepository.readBlogs();
  }

  Future<List<Campaign>> getCampaignsWithPagination() async {
    return await _userRepository.getCampaignsWithPagination();
  }

  Future<List<Campaign>> getCampaigns() async {
    return await _userRepository.getCampaigns();
  }

// Future<String> getBlogPhotoDownloadLink(String id) async {
  //   return await _userRepository.getBlogPhotoDownloadLink(id);
  // }
}
