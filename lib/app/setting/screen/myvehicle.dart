import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finobadivendor/common/snack_bar.dart';
import 'package:finobadivendor/provider/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mappls_gl/mappls_gl.dart';
import 'package:provider/provider.dart';

import '../../../common/dialog.dart';
import '../../../common/map_cradential.dart';

class MyVehicalScreen extends StatefulWidget {
  const MyVehicalScreen({super.key});

  @override
  State<MyVehicalScreen> createState() => _MyVehicalScreenState();
}

class _MyVehicalScreenState extends State<MyVehicalScreen> {
  TextEditingController _pinName = TextEditingController();
  late MapplsMapController mapplsMapController;
  void getPosition() async {
    Position locat = await Geolocator.getCurrentPosition();
    mapplsMapController.moveCamera(CameraUpdate.newLatLngZoom(
        LatLng(locat.latitude, locat.longitude), 16));
  }
  String? pinTitle;
  String? pinIcon;

  List selectedListIcon = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pinTitle = Provider.of<AuthanticationProvider>(context,listen: false).vender!["title"];
    pinIcon = Provider.of<AuthanticationProvider>(context,listen: false).vender!["icon"];
    mapKey();
    getPosition();
    getselectedListIcon();
  }
   Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapplsMapController.addImage(name, list);
  }
    LatLng? location; 
    Symbol? symbol;


  void _addMarker()async{
     await addImageFromAsset("bicycle", "assets/mapIcons/bicycle.png");
    await addImageFromAsset("cycle-rickshaw", "assets/mapIcons/cycle-rickshaw.png");
    await addImageFromAsset("cycling", "assets/mapIcons/cycling.png");
    await addImageFromAsset("kabadistore", "assets/mapIcons/kabadistore.png");
    await addImageFromAsset("pin-store", "assets/mapIcons/pin-store.png");
    await addImageFromAsset("shop", "assets/mapIcons/shop.png");
    await addImageFromAsset("large-truck", "assets/mapIcons/large-truck.png");
    await addImageFromAsset("rickshaw", "assets/mapIcons/rickshaw.png");
    await addImageFromAsset("store", "assets/mapIcons/store.png");
    await addImageFromAsset("pickup-truck", "assets/mapIcons/pickup-truck.png");
    await addImageFromAsset("shop-pin", "assets/mapIcons/shop-pin.png");
    await addImageFromAsset("three-wheeler", "assets/mapIcons/three-wheeler.png");
  if(  Provider.of<AuthanticationProvider>(context,listen: false).vender!["venderType"] ==
                "shop"){
              QuerySnapshot snap =  await FirebaseFirestore.instance.collection('venderMaster').doc(Provider.of<AuthanticationProvider>(context,listen: false).vender!.id).collection("Address").get();
             QueryDocumentSnapshot data = snap.docs.single;
              location = LatLng(data["lat"],data["lng"]);
                }else{
            Position position = await Geolocator.getCurrentPosition();
            location = LatLng(position.latitude,position.longitude);
                }
   symbol =  await mapplsMapController.addSymbol(SymbolOptions(
            textField: pinTitle == 'default'? Provider.of<AuthanticationProvider>(context,listen: false).vender!["shopName"]:pinTitle,
            textColor: "black",
            textOffset: Offset(0, -1.5),
            textSize: 12.0,
              geometry: location,
              iconImage: pinIcon == 'default'? Provider.of<AuthanticationProvider>(context,listen: false).vender!["venderType"] ==
                "shop"? "kabadistore":"three-wheeler":pinIcon));
              print("done");

  }

 void changeIcon(String iconName)async{
  pinIcon = iconName;

   FirebaseFirestore.instance.collection('venderMaster').doc(Provider.of<AuthanticationProvider>(context,listen: false).vender!.id).update({
    "icon": iconName
  }).then((value){
           Provider.of<AuthanticationProvider>(context,listen:false).updateVendorShop();
    mapplsMapController.updateSymbol(symbol!,  SymbolOptions(
            textField: pinTitle == 'default'? Provider.of<AuthanticationProvider>(context,listen: false).vender!["shopName"]:pinTitle,
            textColor: "black",
            textOffset: Offset(0, -1.5),
            textSize: 12.0,
              geometry: location,
              iconImage: iconName,
                ));
             setState((){});

  });
  
 }
 void changeTitle(String icontitle)async{
  pinTitle = icontitle;
   FirebaseFirestore.instance.collection('venderMaster').doc(Provider.of<AuthanticationProvider>(context,listen: false).vender!.id).update({
    "title": icontitle
  }).then((value){
           Provider.of<AuthanticationProvider>(context,listen:false).updateVendorShop();
   mapplsMapController.updateSymbol(symbol!,SymbolOptions( // icontitle
            textField: icontitle,
            textColor: "black",
            textOffset: Offset(0, -1.5),
            textSize: 12.0,
              geometry: location,
              iconImage: pinIcon == 'default'? Provider.of<AuthanticationProvider>(context,listen: false).vender!["venderType"] ==
                "shop"? "kabadistore":"three-wheeler":pinIcon,
                )
                );
                Navigator.pop(context);
             setState((){});
  });
  
 }

  void getselectedListIcon() {
    selectedListIcon =
        Provider.of<AuthanticationProvider>(context,listen: false).vender!["venderType"] ==
                "shop"
            ? shopIcons
            : riderIcon;
    setState(() {});
  }

  List riderIcon = [
    {"name": "bicycle", "icon": "assets/mapIcons/bicycle.png"},
    {"name": "cycling", "icon": "assets/mapIcons/cycling.png"},
    {"name": "cycle-rickshaw", "icon": "assets/mapIcons/cycle-rickshaw.png"},
    {"name": "three-wheeler", "icon": "assets/mapIcons/three-wheeler.png"},
    {"name": "rickshaw", "icon": "assets/mapIcons/rickshaw.png"},
    {"name": "pickup-truck", "icon": "assets/mapIcons/pickup-truck.png"},
    {"name": "large-truck", "icon": "assets/mapIcons/large-truck.png"},
  ];

  List<Map> shopIcons = [
    {"name": "kabadistore", "icon": "assets/mapIcons/kabadistore.png"},
    {"name": "pin-store", "icon": "assets/mapIcons/pin-store.png"},
    {"name": "shop", "icon": "assets/mapIcons/shop.png"},
    {"name": "store", "icon": "assets/mapIcons/store.png"},
    {"name": "shop-pin", "icon": "assets/mapIcons/shop-pin.png"},
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "My Vehical on Map",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              width: size.width,
              height: size.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: size.height * 0.11,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedListIcon.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: (){
                          changeIcon(selectedListIcon[index]["name"] );
                        },
                        child: Container(
                          width: 75,
                          height: size.height * 0.075,
                          decoration: BoxDecoration(
                            border: Border(bottom: 
                               pinIcon == selectedListIcon[index]["name"] || pinIcon == "default" &&( selectedListIcon[index]["name"] == "kabadistore" || selectedListIcon[index]["name"] == "three-wheeler") ?  BorderSide(
                              width: 3,
                              color: Colors.green,
                                ) : BorderSide(width: 0,color: Colors.transparent)
                        
                           )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 32,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.asset(
                                      selectedListIcon[index]["icon"],
                                      width: 40),
                                ),
                              ),
                              Text(
                                selectedListIcon[index]["name"],
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Your Map Pin Name :",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                      Text(
                        "(${pinTitle == "default"? Provider.of<AuthanticationProvider>(context,listen: false).vender!["shopName"]:pinTitle})",
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                      TextButton(
                          onPressed: () {
                            showDialogReuseable(
                                context: context,
                                title: "Change Pin Name",
                                content: TextField(
                                  controller: _pinName,
                                ),
                                yesText: "Change",
                                yesFunc: () {
                                  if(_pinName.text.isNotEmpty){
                                    changeTitle(_pinName.text);
                                    _pinName.text = '';
                                  }else{
                                    Notify.showNotify("Please Enter name");
                                  }
                                });
                          },
                          child: Text("Change"))
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: MapplsMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(25.321684, 82.987289),
                    zoom: 16.0,
                  ),
                  myLocationEnabled: true,
                  myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                  onStyleLoadedCallback: _addMarker,
                  onMapCreated: (MapplsMapController controller) {
                    mapplsMapController = controller;
                  }),
            ),
          ],
        ));
  }
}
