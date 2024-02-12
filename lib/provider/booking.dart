import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import '../common/snack_bar.dart';
import '../notification/fmc_notification.dart';
import '../notification/local_notification.dart';
import 'auth_provider.dart';

class BookingProvider extends ChangeNotifier {
  Future<bool> changeAccepetedStatus(
      BuildContext context, String orderId, String userId) async {
    String code = randomNumeric(5);
    try {
      await FirebaseFirestore.instance
          .collection('OrderBooking')
          .doc(orderId)
          .update({
        "status": code,
      }).then((value) async {
        LocalNotification().showNotification(
            channelId: 10, title: "You Accepeted Successfuly", body: "");
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection("UserMaster")
            .doc(userId)
            .get();
        FmcNotification().fmcPushNotification(
            token: doc["token"],
            title: "Your Schedule booking has been Accepeted Successfuly",
            body: '');
        Navigator.pop(context);
        Notify.showNotify("You Accepeted Successfuly");
      });
      return true;
    } catch (e) {
      // isbooking = false;
      notifyListeners();

      Notify.showNotify(e.toString());
      return false;
    }
  }

  Future<bool> changeDoneStatus(
      BuildContext context, String orderId, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('OrderBooking')
          .doc(orderId)
          .update({
        "status": 'Done',
      }).then((value) async {
        LocalNotification().showNotification(
            channelId: 10, title: "You completed booking", body: "");
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection("UserMaster")
            .doc(userId)
            .get();
        FmcNotification().fmcPushNotification(
            token: doc["token"],
            title: "Your Schedule booking has been Done Successfuly",
            body: '');
        Navigator.pop(context);
        Notify.showNotify("You completed booking");
      });
      return true;
    } catch (e) {
      Notify.showNotify(e.toString());
      return false;
    }
  }

  Future<bool> changeCancelStatus(BuildContext context, String orderId,
      String userId, String reason) async {
    try {
      await FirebaseFirestore.instance
          .collection('OrderBooking')
          .doc(orderId)
          .update({
        "status": 'Cancel: $reason',
      });
      await FirebaseFirestore.instance.collection('CancelRequest').doc().set({
        "type": "vendor",
        "cancelOrderId": orderId,
        "reason": 'Cancel: $reason',
        "date": DateTime.now().toString(),
        "id": Provider.of<AuthanticationProvider>(context, listen: false)
            .vender!
            .id,
      });
      LocalNotification().showNotification(
          channelId: 10, title: "You Cancelled booking", body: "");
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("UserMaster")
          .doc(userId)
          .get();
      FmcNotification().fmcPushNotification(
          token: doc["token"],
          title: "Your Schedule booking has been Cancelled",
          body: reason);
      Notify.showNotify("You Cancelled booking");

      Navigator.pop(context);

      return true;
    } catch (e) {
      Notify.showNotify(e.toString());
      return false;
    }
  }
}
