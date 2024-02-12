import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
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
      appBar: AppBar(
        title: Text("Need Help ?",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 28),),

      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset("assets/images/help.png"),
            Text("Get in touch with us for assistance and Help."),
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