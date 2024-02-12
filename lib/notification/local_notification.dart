import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification{
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> ragisterChannel() async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      "finobadi",
      "finobadi.notification",
      description: "this is a firebase notification",
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    const AndroidNotificationChannel localChannel = AndroidNotificationChannel(
      'finobadi local',
      'local finobadi notification',
      description: 'this is a local notification',
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(localChannel);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
   Future<void> showNotification({required int channelId,required String title,required String body,}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'finobadi',
            channelDescription: 'Sechedule booking notification',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        channelId, title, body, notificationDetails,
        payload: 'Schedule Booked');
  }

}