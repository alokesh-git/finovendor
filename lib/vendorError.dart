
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorError404Page extends StatefulWidget {
  const VendorError404Page({Key? key}) : super(key: key);

  @override
  State<VendorError404Page> createState() => _VendorError404PageState();
}

class _VendorError404PageState extends State<VendorError404Page> {

 String Phone = '';
   String whatsapp = '';

  void getSupportInfo()async {
   DocumentSnapshot value =  await FirebaseFirestore.instance.collection("SupportInfo").doc("uYFAfpJg81m4W1Zi3BAp").get();
   Phone = value["vendorSupportCall"]; 
   whatsapp = value["vendorSupportWhatsApp"]; 

  }
 
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSupportInfo();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // You can use any image asset you want here
            Image.asset('assets/images/404.png'),
            const Text(
              '404',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Your authority has Denied',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
           OutlinedButton.icon(onPressed: ()async{
             await FlutterPhoneDirectCaller.callNumber(
                                      Phone);
            }, icon: Icon(Icons.call), label: Text("Call")),
            OutlinedButton.icon(onPressed: ()async{ 
              
              final url = 'whatsapp://send?phone=${'+91$whatsapp'}&text=${"Hello"}';
                     if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch WhatsApp';
      }
            }, icon: Icon(Icons.wechat_sharp), label: Text("Whatsapp")),
          ],
        ),
      ),
    );
  }
}
