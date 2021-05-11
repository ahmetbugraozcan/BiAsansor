import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_biasansor/screens/tab_pages/profile_page.dart';
import 'package:flutter_biasansor/screens/show_finished_shipping_to_admin.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:flutter_biasansor/widgets/platform_duyarli_alert_dialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

// AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.high,
// );
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  //Bildirim geldiği anda datayı elde ettiğimiz alan
  final dynamic data = message.data;
  print('Data in background : ${data.toString()}');
  // final notificationAppLaunchDetails =
  //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  // print('Yeni metoddan gelen data : ' +
  //     notificationAppLaunchDetails.didNotificationLaunchApp.toString());
  NotificationHandler.showNotification(data);
}

class NotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final NotificationHandler _singleton = NotificationHandler._internal();
  factory NotificationHandler() {
    return _singleton;
  }
  NotificationHandler._internal();
  BuildContext myContext;

  // ignore: always_declare_return_types
  initializeFCMNotifications(BuildContext context) async {
    myContext = context;
    var _viewModel = Provider.of<ViewModel>(context, listen: false);
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    //yeni metod

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    //eğer adminse admin topicine kaydet ve bildirimleri gönder diyebiliriz
    if (_viewModel.user.isAdmin) {
      await _firebaseMessaging.subscribeToTopic("admin");
    }

    if (_viewModel.user != null) {
      String token = await _firebaseMessaging.getToken();
      var _currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .doc('tokens/' + _currentUser.uid)
          .set({'token': token});
    }

    //token kullanmamız gerekiyor mu emin değilim admine sub olmuş kullanıcılara bildirim göndersek yeterli bence

    // print("token : " + token);

    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print('initialmessage tetiklendi : ' + message.data.toString());
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var notification = message.notification;
      var android = message.notification?.android;

      print('ONMESSAGE ÇALIŞTI');
      print('onmessage tetiklendi data : ' +
          message.data['message'] +
          ' title ' +
          message.data['title']);
      showNotification(message.data);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Onmessageopened  : ' + message.data.toString());
    });
  }

  static void showNotification(Map<String, dynamic> data) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1234', 'Yeni Mesaj', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');

    var IOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, IOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, data['title'], data['message'], platformChannelSpecifics,
        payload: jsonEncode(data));
    // await flutterLocalNotificationsPlugin.show(
    //     0, data['title'], data['message'], platformChannelSpecifics,
    //     payload: data['payload']);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      Map<String, dynamic> notification = await jsonDecode(payload);
      debugPrint('notification payload : $payload');

      Route r = CupertinoPageRoute(
          builder: (context) => ShowFinishedShippingToAdmin(
                payload: notification["payload"].toString(),
              ));
      await Navigator.of(myContext, rootNavigator: true).push(r);
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {}
}
