import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finobadivendor/app/Order/screen/order_screen.dart';
import 'package:finobadivendor/app/help/help_screen.dart';
import 'package:finobadivendor/app/home/screen/DefaultScreen.dart';
import 'package:finobadivendor/app/setting/screen/setting_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../common/snack_bar.dart';
import '../../../common/uri.dart';
import '../../../provider/auth_provider.dart';
import '../widget/profileWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool onDuties = false;

  int _screen = 0;

  List pages = [DefaultScreen(),OrderScreen(),SettingScreen(),HelpScreen()];

  void configureBackgroundLocationTracking(isbool) {

  // Create a LocationSettings object
  LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Minimum distance (in meters) between location updates
  );
  String uid = Provider.of<AuthanticationProvider>(context,listen: false).vender!.id;
  String icon = Provider.of<AuthanticationProvider>(context,listen: false).vender!["icon"];
  String title = Provider.of<AuthanticationProvider>(context,listen: false).vender!["title"];

  // Subscribe to location changes
   StreamSubscription stream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((position) {
    // Send the location data to the HTTP endpoint
     try {
    http.post(Uri.parse('$uri/rider_updates/$uid'),body: jsonEncode({
     "shopType": "rickshaw", "latitude":position.latitude ,"longlatitude" : position.longitude,"icon":icon,"title":title,"onDuty":isbool
    }),headers: {'Content-Type': 'application/json'},);
    print("Saved");
  } catch (e) {
    print(e.toString());
   Notify.showNotify(e.toString()); 
  }
  });
   if(isbool == false){
   stream.cancel();
    print("Cancel stream");

   }
}

  Future<bool> requestBackgroundLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    // Permission denied or denied forever, display error message here
    permission = await Geolocator.requestPermission();
    return false;
  } else if (permission == LocationPermission.whileInUse) {
    // Permission granted for while in use, display warning here
    permission = await Geolocator.requestPermission();
    return false;
  } else {
    // Permission granted for background use, continue with desired operation
    return true;
  }
}
  @override
  Widget build(BuildContext context) {
     DocumentSnapshot? vendor = Provider.of<AuthanticationProvider>(context,listen:true).vender;
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoSwitch(value: vendor!["onDuty"] , onChanged: (val)async{
            if(vendor["venderType"] == "shop"){
         await Provider.of<AuthanticationProvider>(context,listen:false).switchDutyShop(context,val);
            }else{
          if(await requestBackgroundLocationPermission()){
         await Provider.of<AuthanticationProvider>(context,listen:false).switchDuty(context,val);
          configureBackgroundLocationTracking(val);
         }else{

          requestBackgroundLocationPermission();
         }
          
            }
        }),
        title: Text("Welcome ! ${vendor!["shopName"] ?? ''}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900),),
        actions: [
          InkWell(
            onTap: (){
              showProfile(context);
            },
            child: CircleAvatar(
             backgroundColor: Colors.white,
              child: Icon(Icons.person),
            ),
          ),
          SizedBox(width: 10,)
      ],
      flexibleSpace: Container(decoration:  BoxDecoration( gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [vendor!["onDuty"]? Colors.green.shade50 :Colors.red.shade50, vendor!["onDuty"]? Colors.green.shade500 : Colors.red.shade500],),)
      ),
    ),
    body: pages[_screen],
    bottomNavigationBar: 
    BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.shifting,
      enableFeedback: true,
      currentIndex: _screen,
      onTap: (value) {
        setState(() {
          _screen = value;
        });
      },
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.cube_box),
      label: 'Orders',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.help),
      label: 'Help',
    ),
  ],
)
    );
  }
}