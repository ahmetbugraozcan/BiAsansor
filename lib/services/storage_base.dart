import 'dart:io';

abstract class StorageBase {
  Future<String> uploadFile(
      String userID, String fileType, File yuklenecekDosya);
  Future<String> uploadBlogImage(String blogID, File blogPhoto);
  Future<String> getBlogPhotoDownloadLink(String id);
}
