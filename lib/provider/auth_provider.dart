import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finobadivendor/common/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import '../app/auth/screen/auth_screen.dart';
import '../app/home/screen/home_screen.dart';
import '../common/uri.dart';

class AuthanticationProvider extends ChangeNotifier {
  // Define and initialize _verificationId
  bool sendOtp = false;
  bool resendOtp = false;
  String? _verificationId;
  PhoneAuthCredential? credential;
  DocumentSnapshot? vender;
  String phoneno = '';

  void initShop(BuildContext context, String uid) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('venderMaster')
          .doc(uid)
          .get();
      if (snapshot.exists) {
        vender = snapshot;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PhoneAuthMiddlewareScreen(),
            ));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void initVendor(DocumentSnapshot vendor) async {
    vender = vendor;
  }
    void updateVendorShop() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot vendorData =  await FirebaseFirestore.instance.collection('venderMaster').doc(uid).get();
    vender = vendorData;
    updateShopNetwork();
  }

  Future<void> switchDuty(BuildContext context, bool duty) async {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
          child: SizedBox(
              width: 50, height: 50, child: CircularProgressIndicator())),
    );
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('venderMaster')
        .doc(uid)
        .update({
      "onDuty": duty,
    });

    vender = await FirebaseFirestore.instance
        .collection('venderMaster')
        .doc(uid)
        .get();
    notifyListeners();
    Navigator.pop(context);
  }

  Future<void> switchDutyShop(BuildContext context, bool duty) async {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
          child: SizedBox(
              width: 50, height: 50, child: CircularProgressIndicator())),
    );
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('venderMaster')
        .doc(uid)
        .update({
      "onDuty": duty,
    });

    vender = await FirebaseFirestore.instance
        .collection('venderMaster')
        .doc(uid)
        .get();
     http.post(
      Uri.parse('$uri/shop_vendor_Update/$uid'),
      body: jsonEncode(
          {"onDuty": duty, "title": vender!["title"], "icon": vender!["icon"]}),
      headers: {'Content-Type': 'application/json'},
    );
    notifyListeners();
    Navigator.pop(context);
  }
  void updateShopNetwork()async{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
       http.post(
      Uri.parse('$uri/shop_vendor_Update/$uid'),
      body: jsonEncode(
          {"onDuty": vender!["onDuty"], "title": vender!["title"], "icon": vender!["icon"]}),
      headers: {'Content-Type': 'application/json'},);
    } catch (e) {
      Notify.showNotify(e.toString());
    }
  }

  Future<void> verifyPhoneNumber(BuildContext context, String phone) async {
    phoneno = phone;
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Sign in with the credential
          credential = credential;
          await verifyOtp(context: context);
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle the failure
          Notify.showNotify(e.message ??
              'An error occurred while verifying your phone number');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Update the UI with the verification id
          Navigator.pop(context);
          sendOtp = true;
          notifyListeners();
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          resendOtp = true;
          notifyListeners();
          Notify.showNotify(
              'The OTP code has expired. Please request a new one');
        },
      );
    } catch (e) {
      Notify.showNotify('An error occurred while verifying your phone number');
    }
  }

  Future<void> verifyOtp({required BuildContext context, String? otp}) async {
    try {
      credential ??= PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp!,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential!);
      Navigator.pop(context);
      String? token = await FirebaseMessaging.instance.getToken();
      FirebaseFirestore.instance
          .collection("venderMaster")
          .where("phone", isEqualTo: userCredential.user!.phoneNumber)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          sendOtp = false;
          value.docs.first.reference
              .update({"uid": userCredential.user!.uid, "token": token});
          initShop(context, userCredential.user!.uid);
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PhoneAuthMiddlewareScreen(),
              ));
        }
      });
    } on FirebaseAuthException catch (e) {
      Notify.showNotify(e.message ??
          'An error occurred while signing in with your phone number');
    }
  }

  void editPhone() {
    sendOtp = false;
    notifyListeners();
  }

  void reSendOtp(BuildContext context) {
    resendOtp = false;
    notifyListeners();
    verifyPhoneNumber(context, phoneno);
  }

  void saveMaterial(Map<String, dynamic> material) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("venderMaster")
        .doc(uid)
        .collection("Materials")
        .doc()
        .set(material);
  }

  void updateMaterial(Map<String, dynamic> material, id) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("venderMaster")
        .doc(uid)
        .collection("Materials")
        .doc(id)
        .set(material);
  }

  void delteMaterial(String id) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection("venderMaster")
        .doc(uid)
        .collection("Materials")
        .doc(id)
        .delete();
  }
}
