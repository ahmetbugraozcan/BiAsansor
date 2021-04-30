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

abstract class DBBase {
  Future<bool> saveUser(UserAcc user);
  Future<UserAcc> readUser(String id);
  Future<bool> updateUserLocation(String id, String newLocation);
  Future<bool> updateUserName(String id, String newUserName);
  Future<bool> updateProfilePhoto(String id, String profilePhotoUrl);
  Future<bool> updatePhoneNumber(String id, String phoneNumber);
  Future<Shipper> getShipperDetails(String id);
  Future<List<ShipperMini>> getAvailableShippersAscending(Order order);
  Future<List<ShipperMini>> getAvailableShippersDescending(Order order);
  Future<List<String>> getAllLocations();
  Future<bool> addShipperToDatabase(Shipper shipper);
  Future<bool> addComment(Shipper shipper, Comment comment, Rating rating,
      String finishedShippingID);
  Future<List<Rating>> getRatings(String shipperID);
  Future<List<Comment>> getComments(String shipperID);
  Future<bool> addFinishedShipping(FinishedShipping finishedShipping);
  Future<List<FinishedShipping>> getFinishedShippings(String userID);
  Future<List<FinishedShipping>> getFinishedShippingsWithPagination(
      String userID);
  Future<List<FinishedShipping>> getAllFinishedShippingsForAdmin();
  Future<List<FinishedShipping>>
      getAllFinishedShippingsForAdminWithPagination();
  Future<bool> addMembershipFormToDatabase(MembershipForm membershipForm);
  Future<List<MembershipForm>> getMembershipForms();
  Future<List<MembershipForm>> getMembershipFormsWithPagination();
  Future<String> addBlog(Blog blog);
  Future<List<Blog>> readBlogs();
  Future<List<Blog>> readBlogsWithPagination();
  Future<List<Campaign>> getCampaigns();
  Future<List<Campaign>> getCampaignsWithPagination();
}
