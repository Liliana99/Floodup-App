import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:floodup/AppLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:floodup/login.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:floodup/LocationService.dart';
import 'package:floodup/globals.dart' as globals;
import 'map.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<bool> isLoggedIn() async{
  final _db_instance = Firestore.instance;

  FirebaseUser curUser = await FirebaseAuth.instance.currentUser();

  if(curUser == null){
    globals.firUserId = "";
    globals.userFullName = "";
    globals.userEmail = "";
    globals.bLoggedIn = false;
    globals.isMapDisplayed = false;
    return false;
  }

  globals.firUserId = curUser.uid;
  if(curUser.displayName != null && curUser.displayName != ""){
    globals.userFullName = curUser.displayName;
  }
  globals.userEmail = curUser.email;
  globals.bLoggedIn = true;

  try{
    var subVal = await _db_instance.collection('subscriptions').document(curUser.email).get();
    if(subVal.exists){
      globals.isSubscribed = subVal["subscribed"];
    }
    print("subscription value = ${globals.isSubscribed}");
  }on Exception catch(error){
    print(error);
  }

  return true;
}

void main() async{
  bool _loginStatus = await isLoggedIn();

  runApp(MyApp(loginStatus: _loginStatus,));
}

class MyApp extends StatefulWidget {

  MyApp({this.loginStatus = false});
  bool loginStatus;

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Location location = new Location();
  String error;

  @override
  void initState(){
    super.initState();


//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print('on message $message');
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print('on resume $message');
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print('on launch $message');
//      },
//    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: false, alert: true));


    _firebaseMessaging.getToken().then((token){
      print(token);
    });
    
    initPlatformState();
  }

  void initPlatformState() async{
    LocationData my_Location;

    try{

      my_Location = await location.getLocation();
      error = "";
      print("My Location is = ${my_Location.latitude} ,  ${my_Location.longitude}");

    } on PlatformException catch(e) {

      if(e.code == 'PERMISSION_DENIED'){
        error = 'Permission denied.';
      }
      else if(e.code == "PERMISSION_DENIED_NEVER_ASK") {
        error = 'Permission denied - please ask the user to enable it from  the app settings';
      }

      my_Location = null;
    }

    setState(() {
      globals.currentLocation = new UserLocation(latitude: my_Location.latitude, longitude: my_Location.longitude);
    });
  }

  Widget build(BuildContext context){
    const MaterialColor white = const MaterialColor(
      0xFFFFFFFF,
      const <int, Color>{
        50: const Color(0xFFFFFFFF),
        100: const Color(0xFFFFFFFF),
        200: const Color(0xFFFFFFFF),
        300: const Color(0xFFFFFFFF),
        400: const Color(0xFFFFFFFF),
        500: const Color(0xFFFFFFFF),
        600: const Color(0xFFFFFFFF),
        700: const Color(0xFFFFFFFF),
        800: const Color(0xFFFFFFFF),
        900: const Color(0xFFFFFFFF),
      },
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'FloodUp',
      theme: ThemeData.light(),
      supportedLocales: [
        Locale('en'),
        Locale('fr'),
        Locale('es'),
        Locale('ca')
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales){
        for(var supportedLocale in supportedLocales){
          if(supportedLocale.languageCode == locale.languageCode){
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: widget.loginStatus ? Map() : Login(),
    );
  }
}


