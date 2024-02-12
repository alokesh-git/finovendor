import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finobadivendor/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/dialog.dart';

void showProfile(context){
  showDialog(barrierColor: Colors.transparent,context: context, builder: (context) {
    Size size = MediaQuery.of(context).size;
     DocumentSnapshot? vendor = Provider.of<AuthanticationProvider>(context,listen:true).vender;
    return Center(
      child: Container(
        width: 280,
        height: size.height * 0.5,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(

          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
           BoxShadow(
          offset: Offset(5 ,5),
          blurRadius: 10,
          color: Colors.black54,
          )
          ]
        ),
        child: Flex(
          direction: Axis.vertical,
           children: [
            Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(CupertinoIcons.clear))],
            ),
            Expanded(child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: CachedNetworkImageProvider(vendor!["shopImage"]),
                    child: vendor["shopImage"].toString().isEmpty? Icon(Icons.person) : null,
                  ),
                  Text(vendor["shopName"],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800,color:Colors.black),),
                  Card(color: Colors.white, surfaceTintColor:Colors.white,child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.call),
                        Text(vendor["phone"],style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                      ],
                    ),
                  ))
                
                ],
              ),
            )),
            TextButton.icon(onPressed: (){
              showDialogReuseable(context: context, title: "Log Out", content: Text("Are you Sure ?"), yesText: "Logout", yesFunc: (){
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Navigator.pop(context);
              });
            }, icon: Icon(Icons.logout,color: Colors.red,), label: Text("Log Out",style: TextStyle(color:Colors.red,fontWeight: FontWeight.w700,fontSize: 18),))
           ],
        ),
      ),
    );
  },);
}