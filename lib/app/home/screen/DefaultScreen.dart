import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth_provider.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
     DocumentSnapshot? vendor = Provider.of<AuthanticationProvider>(context,listen:true).vender;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Container(
            padding: EdgeInsets.all(14),
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(8.0), 
              gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [vendor!["onDuty"]? Colors.green.shade50 :Colors.red.shade50, vendor!["onDuty"]? Colors.green.shade500 : Colors.red.shade500],),),
      
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.smart_button,size: 30,),
                Text("You are currenty  ${vendor["onDuty"]? "Online ":"Offline"}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
              ],
            ),
          ),
           Divider(),
          Center(child:Text("Your Orders",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
          Divider(),
          Container(
            padding: EdgeInsets.all(14),
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(8.0), 
              gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.green.shade50, Colors.green.shade500],),),
      
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               
                
                Text("Your New Orders",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                CircleAvatar(
                  child: Text("0"),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(14),
            margin: EdgeInsets.symmetric(vertical: 8),

            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(8.0), 
              gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.green.shade50 , Colors.green.shade500 ],),),
      
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               
                
                Text("Your Pending Orders",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
              CircleAvatar(
                  child: Text("0"),
                ),
              ],
            ),
          ),
        
          Container(
            padding: EdgeInsets.all(14),
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(8.0), 
              gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [ Colors.green.shade50 , Colors.green.shade500 ],),),
      
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               
                
                Text("Your Completed Orders",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                CircleAvatar(
                  child: Text("0"),
                ),
              ],
            ),
          ),
           Container(
            padding: EdgeInsets.all(14),
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(8.0), 
              gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.red.shade50, Colors.red.shade500],),),
      
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                
                Text("Your Cancel Orders",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
               CircleAvatar(
                  child: Text("0"),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}