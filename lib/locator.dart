import 'package:flutter_biasansor/repository/repository.dart';
import 'package:flutter_biasansor/services/fake_auth_service.dart';
import 'package:flutter_biasansor/services/firebase_auth_service.dart';
import 'package:flutter_biasansor/services/firebase_storage_service.dart';
import 'package:flutter_biasansor/services/firestore_database_service.dart';
import 'package:flutter_biasansor/services/notification_sender_service.dart';
import 'package:flutter_biasansor/utils.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Repository());
  locator.registerLazySingleton(() => ViewModel());
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => FirestoreDatabaseService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => Utils());
  locator.registerLazySingleton(() => NotificationSenderService());
}
