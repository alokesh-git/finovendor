import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class FmcNotification{
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications() async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,);
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      AppSettings.openAppSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
     BigTextStyleInformation bigTextStyleInformation =
            BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
        );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "finobadi.notification",
      "finobadi.notification",
      channelDescription: "this is a firebase notification",
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: bigTextStyleInformation,
      playSound: true,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    _flutterLocalNotificationsPlugin.show(
      10,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
      payload: message.data['click_action']
    );
  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    messaging.onTokenRefresh.listen((event) {
      token = event;
    });
    return token!;
  }

 void fmcPushNotification({required String token, required String title,required String body})async{
 try {
      await http
          .post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAANSAwqUU:APA91bEE2srxIgXioWO9ROjSLqtWNT4VxDP7IRuSP7aVsKBqDzxYav2AGuGQubAkFhHRy9PdyVbceCBpnnfQZ-9MXmz4Kx_KP2HlW4QrwEfA9WbVx8Uzs6-jdLms0vdHabKKhZF5LCG7'
            },
            body: json.encode({
              'to': token,
              "notification": {
                "title": title,
                "body": body
              },
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '10',
              'status': 'done'
            },
            }),
          )
          .then((value) => print(value.body));
      print('FCM request for web sent!');
    } catch (e) {
      print(e);
    }
  }

}