import 'package:finobadivendor/firebase_options.dart';
import 'package:finobadivendor/notification/local_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'app/auth/screen/auth_screen.dart';
import 'app/home/screen/home_screen.dart';
import 'notification/fmc_notification.dart';
import 'provider/auth_provider.dart';
import 'provider/booking.dart';
import 'vendorError.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FmcNotification().initLocalNotifications();
  FmcNotification().showNotification(message);
}

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
FmcNotification fmcNotification = FmcNotification();
  LocalNotification localNotification = LocalNotification();
fmcNotification.initLocalNotifications();
  localNotification.ragisterChannel();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.getInitialMessage();
  fmcNotification.requestNotificationPermission();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      print('A new onMessageBackgroundApp event was published!');
      fmcNotification.showNotification(message);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      fmcNotification.showNotification(message);
    }
  });
SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
  runApp(
    MultiProvider(providers: [ // 
    ChangeNotifierProvider<AuthanticationProvider>(
        create: (context) => AuthanticationProvider()),
          ChangeNotifierProvider<BookingProvider>(
        create: (context) => BookingProvider()),
  ],
    // DevicePreview(
  //     enabled: true,
  //     tools: [
  //       ...DevicePreview.defaultTools,
      
  //     ],
  //   builder: (context) => 
   child :const MyApp())
    //)
    );});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finobadi Vendor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home:  StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                User? user = FirebaseAuth.instance.currentUser;
                  return FutureBuilder(future: FirebaseFirestore.instance.collection('venderMaster').doc(user!.uid).get(), builder: (context, snap) {
                         if (snap.connectionState == ConnectionState.done && snap.hasData) {
                             print(snap.data!["shopName"]);
                           if (snap.hasData) {
                            print(snap.data!["authority"]);
                             if (snap.data!["authority"] == true) {
                              Provider.of<AuthanticationProvider>(context,listen: false).initVendor(snap.data!);
                              return const HomeScreen();
                               
                             }else{
                            return const VendorError404Page();
                             }
                           }else{
                            return const PhoneAuthMiddlewareScreen();
                           }
                         }else{
                           return Image.asset(
                        "assets/images/snap.gif",
                        fit: BoxFit.fitHeight,
                      );
                         }
                       },);
              } else {
                return const PhoneAuthMiddlewareScreen();
              }
            }),
    );
  }
}

