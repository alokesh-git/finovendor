import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerScreen extends StatefulWidget {
  const PartnerScreen({super.key});

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  String Phone = '';
   String whatsapp = '';

  void getSupportInfo()async {
   DocumentSnapshot value =  await FirebaseFirestore.instance.collection("SupportInfo").doc("uYFAfpJg81m4W1Zi3BAp").get();
   Phone = value["joinVendorCall"]; 
   whatsapp = value["joinVendorWhatsapp"]; 

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
      appBar: AppBar(backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(18.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(child: Text("Join Finobadi as a Partner ( Kabadiwala or Scrap Store)",style: TextStyle(color: Colors.black,fontSize: 32,fontWeight: FontWeight.w800),)),
            Image.network("https://img.freepik.com/free-vector/helping-partner-concept-illustration_114360-8867.jpg?w=996&t=st=1707039537~exp=1707040137~hmac=451b5fd56ae72a79aecd0bfedfef05623ae9779197bd3d61229ee0cb065cb00e",fit: BoxFit.fitWidth,),
           ElevatedButton.icon(onPressed: ()async{
            await FlutterPhoneDirectCaller.callNumber(
                                      Phone);
           }, icon: Icon(Icons.call), label: Text("Call to Us")),
           ElevatedButton.icon(onPressed: ()async{
                 final url = 'whatsapp://send?phone=${'+91$whatsapp'}&text=${"Hello"}';
                     if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch WhatsApp';
      }
           }, icon: Icon(Icons.wechat_sharp), label: Text("Whatsapp to Us")),
        
          ],
        ),
      ),
    );
  }
}