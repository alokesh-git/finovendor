// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:mappls_gl/mappls_gl.dart';
// import 'package:mappls_direction_plugin/mappls_direction_plugin.dart';


// class MapDirection extends StatefulWidget {
//   @override
//   _MapDirectionState createState() => _MapDirectionState();
// }

// class _MapDirectionState extends State<MapDirection> {
//      String ACCESS_TOKEN = "c1a6d80c53849abdd8eaa476735396c5";
//     String REST_API_KEY = "c1a6d80c53849abdd8eaa476735396c5";
//     String ATLAS_CLIENT_ID =
//       "33OkryzDZsL8vVpXsQoDK9AoKpHAsjNMxCgyC0xlH9kpExAsjgsHcQ3QZaGHdv1fDOs3yi3Ek-Pst93jw1D0gOuup5r_uVhv";
//     String ATLAS_CLIENT_SECRET =
//       "lrFxI-iSEg-v-cGe8Jdmdqg7CD1P34ufGjObVmp3qgIzQMMi7eoOMy3c9f-4nYzFNKMpLrIdF1BdR1PHN5df8z3KGxyyloX1SL3JsB86py8=";

//   DirectionCallback _directionCallback = DirectionCallback(null, null);

//   @override
//   void initState() {
//     super.initState();
//     MapplsAccountManager.setMapSDKKey(ACCESS_TOKEN);
//     MapplsAccountManager.setRestAPIKey(REST_API_KEY);
//     MapplsAccountManager.setAtlasClientId(ATLAS_CLIENT_ID);
//     MapplsAccountManager.setAtlasClientSecret(ATLAS_CLIENT_SECRET);
//   }

//   Future<void> openMapplsDirectionWidget() async {
//     DirectionCallback directionCallback;
//     DirectionSettings settings = DirectionSettings();
//     PlaceOptions placeOptions= PlaceOptions(
//         tokenizeAddress: settings.tokenizeAddress,
//         saveHistory: settings.saveHistory,
//        historyCount: settings.historyCount!=null?int.parse(settings.historyCount!):null,
//       backgroundColor: settings.backgroundColor,
//       toolbarColor: settings.toolbarColor,
//       toolbarTintColor: settings.toolbarTintColor,
//       zoom: settings.zoom!=null?double.parse(settings.zoom!):null,
//       //pod:
//       location: settings.longitude!=null&&settings.latitude!=null?LatLng(double.parse(settings.latitude!),double.parse(settings.longitude!)):null,
//       filter: settings.filter!=null?settings.filter:null

//     );

//     DirectionOptions options = DirectionOptions(
//       showStartNavigation: settings.showStartNavigation,
//       showAlternative: settings.showAlternative,
//       steps: settings.showSteps,
//       resource: settings.resource,
//       profile: settings.profile,
//       overview: settings.overView,
//       excludes:settings.excludes.length == 0 ?null:settings.excludes,
//       searchPlaceOption: placeOptions,
//       destination:
//       settings.mapplsPin != null
//           ?
//       DirectionPoint(settings.placeName!, settings.placeAddress!,mapplsPin: settings.mapplsPin):
//       settings.dLng != null&&settings.dLat!=null?
//       DirectionPoint(settings.placeName!, settings.placeAddress!,location: LatLng(double.parse(settings.dLat!),double.parse(settings.dLng!
//       ))):null
//     );
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       directionCallback = await openDirectionWidget(directionOptions:options );
//     } on PlatformException {
//       directionCallback = DirectionCallback(null, null);
//     }
//     print(json.encode(directionCallback.directionResponse?.toMap()));

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       _directionCallback = directionCallback;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Direction Example'),
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(
//                 Icons.settings,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 Navigator.pushNamed(context, 'SettingWidget');
//               },
//             )
//           ],
//         ),
//         body: Center(
//             child: Column(children: [
//               SizedBox(
//                 height: 20,
//               ),
//               Text(_directionCallback.selectedIndex == null
//                 ? 'Selected Index: '
//                 : 'Selected Index: ${_directionCallback.selectedIndex}'),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(_directionCallback.directionResponse?.waypoints == null
//                 ? 'Distance: '
//                 : 'Distance: ${_directionCallback.directionResponse?.routes?[0].distance}'),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(_directionCallback.directionResponse?.waypoints == null
//                 ? 'Duration: '
//                 : 'Duration: ${_directionCallback.directionResponse?.routes?[0].duration}'),
//               SizedBox(
//                 height: 20,
//               ),
//                TextButton(
//                 child: Text('Open Direction Widget'),
//                 onPressed: () => {openMapplsDirectionWidget()})
//             ])
//         ),
//       ),
//     );
//   }
// }