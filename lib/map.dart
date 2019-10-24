import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:floodup/EventDetail.dart';
import 'package:floodup/LocationService.dart';
import 'package:floodup/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:floodup/filterby.dart';
import 'package:floodup/aboutus.dart';
import 'package:floodup/resources.dart';
import 'package:floodup/categories.dart';
import 'package:floodup/publish.dart';
import 'package:floodup/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floodup/hownd-progressindicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'AppLocalizations.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  var all_Event_Markers = [];
  var event_datas = [];
  var selected_category = 0;
  BitmapDescriptor event_marker_image;
  BitmapDescriptor event_marker_image_green;
  BitmapDescriptor event_marker_image_orange;

  StreamSubscription <LocationData> locationSubscription;
  Location location = new Location();

  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(globals.currentLocation.latitude, globals.currentLocation.longitude),
    zoom: 11,
  );

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  GoogleMapController map_controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    locationSubscription = location.onLocationChanged().listen((result){
      globals.currentLocation = new UserLocation(latitude: result.latitude, longitude: result.longitude);
      print("location = " + globals.currentLocation.latitude.toString() + " - " + globals.currentLocation.longitude.toString());
      if(globals.currentLocation.latitude != 0 && globals.currentLocation.longitude != 0 && !globals.isMapDisplayed){
        map_controller.moveCamera(CameraUpdate.newLatLng(LatLng(globals.currentLocation.latitude, globals.currentLocation.longitude)));
        globals.isMapDisplayed = true;
        print("Map Updated");
      }
    });

    getBytesFromAsset('assets/images/event_mark.png', 45).then((value) {
      setState(() {
        event_marker_image = BitmapDescriptor.fromBytes(value);
      });
    });

    getBytesFromAsset('assets/images/event_mark_green.png', 45).then((value) {
      setState(() {
        event_marker_image_green = BitmapDescriptor.fromBytes(value);
      });
    });

    getBytesFromAsset('assets/images/event_mark_orange.png', 45).then((value) {
      setState(() {
        event_marker_image_orange = BitmapDescriptor.fromBytes(value);
      });
    });

    Future.delayed(Duration.zero, () {
      LoadWeatherEvents();
    });

  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  LoadWeatherEvents({int category = 0})
  {
    event_datas = [];
    all_Event_Markers = [];

    HOWNDProgressIndicator.showProgress(context, isTransparent: true);

    if(category == 0) {
      Firestore.instance.collection('events').where('status', isEqualTo: 1).getDocuments().then((docs) {
        if(docs.documents.isNotEmpty) {
          ProcessEvents(docs);
        }

        HOWNDProgressIndicator.hideProgress();
      });
    }
    else {
      Firestore.instance.collection('events').where('category', isEqualTo: category.toString()).where('status', isEqualTo: 1).getDocuments().then((docs) {
        if(docs.documents.isNotEmpty) {
          ProcessEvents(docs);
        }
        HOWNDProgressIndicator.hideProgress();
      });
    }

    setState(() {

    });
  }

  ProcessEvents(QuerySnapshot docdatas) {
    double bottom = MediaQuery.of(context).viewPadding.bottom;
    for(int i = 0; i < docdatas.documents.length; ++ i){
      List<String> imageFileArray = [];
      String smallImageUrl = "";
      print("aaaaa ${List.from(docdatas.documents[i].data["image_files"]).length.toString()}");
      if(docdatas.documents[i].data["image_files"] != null && List.from(docdatas.documents[i].data["image_files"]).length > 0) {
        imageFileArray = List.from(docdatas.documents[i].data["image_files"]);
        smallImageUrl = imageFileArray[0];
      }

      event_datas.add(docdatas.documents[i].data);

      all_Event_Markers.add(Marker(
          markerId: MarkerId(docdatas.documents[i].documentID),
          draggable: false,
          onTap:(){
            showModalBottomSheet(context: context,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {

                  List<String> categories = <String>[
                    AppLocalizations.of(context).translate('category_floods'),
                    AppLocalizations.of(context).translate('category_storm'),
                    AppLocalizations.of(context).translate('category_landslide'),
                    AppLocalizations.of(context).translate('category_seastorm'),
                    AppLocalizations.of(context).translate('category_snowfalls'),
                    AppLocalizations.of(context).translate('category_droughts'),
                    AppLocalizations.of(context).translate('category_forestfire'),
                    AppLocalizations.of(context).translate('category_windstorm'),
                    AppLocalizations.of(context).translate('category_other'),
                    AppLocalizations.of(context).translate('category_adaptation'),
                    AppLocalizations.of(context).translate('category_badpractice')
                  ];

                  return GestureDetector(
                    onTap: (){
                      //print("tapped");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventDetail(
                              images: imageFileArray,
                              publisherName: docdatas.documents[i].data["publisher"] == null ? "Unknown" : docdatas.documents[i].data["publisher"],
                              eventCategory: categories[int.parse(docdatas.documents[i].data["category"]) - 1],
                              eventDate: docdatas.documents[i].data['date'],
                              eventLocation: docdatas.documents[i].data['placename'],
                              caughtAttention: docdatas.documents[i].data['attention'],
                              informationData: docdatas.documents[i].data['information'],
                              isUpload: docdatas.documents[i].data['uploadobservation'],
                              climateRating: docdatas.documents[i].data['rating_climate'],
                              why: docdatas.documents[i].data['rating_climate_why'],
                              uploadRating: docdatas.documents[i].data['rating_upload'],
                              botherRating: docdatas.documents[i].data['rating_bother'],
                              reduceImpact: docdatas.documents[i].data['reduce_impact'],
                            )
                        ),
                      );
                    },
                    child: Container(
                      height: 320,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, bottom + 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ListView(
                        padding: const EdgeInsets.all(0),
                        children: <Widget>[
                          Container(
                              height: 180,
                              child: Stack(
                                children: <Widget>[
                                  CachedNetworkImage(
                                    imageUrl: smallImageUrl,
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.only(
                                            topLeft: const Radius.circular(10.0),
                                            topRight: const Radius.circular(10.0)),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    //errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.close, color: smallImageUrl == "" ? Colors.black : Colors.white)
                                    ),
                                  )
                                ],
                              )
                          ),
                          Container(
                            padding: const EdgeInsets.all(22),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(
                                        categories[int.parse(docdatas.documents[i].data["category"]) - 1],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                      Text(
                                        docdatas.documents[i].data['date'],
                                        style: TextStyle(
                                            color: Color(0xff787993),
                                            fontSize: 15,
                                            height: 1.2
                                        ),
                                      ),
                                      Container(height: 15),
                                      Row(
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/images/event_marker1.png',
                                            width: 18, height: 18,
                                          ),
                                          Container(width: 8),
                                          Expanded(
                                            child: Text(
                                              docdatas.documents[i].data['placename'],
                                              style: TextStyle(
                                                  color: Color(0xff787993),
                                                  fontSize: 14,
                                                  height: 1.2
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                Image.asset(
                                  'assets/category_icons/' + docdatas.documents[i].data["category"] + '.png',
                                  width: 80, height: 80,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          position: LatLng(docdatas.documents[i].data["location"].latitude, docdatas.documents[i].data["location"].longitude),
          icon: docdatas.documents[i].data["category"] == "10" ? event_marker_image_green : docdatas.documents[i].data["category"] == "11" ? event_marker_image_orange : event_marker_image
      ));
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    List<String> categories = <String>[
      AppLocalizations.of(context).translate('category_floods'),
      AppLocalizations.of(context).translate('category_storm'),
      AppLocalizations.of(context).translate('category_landslide'),
      AppLocalizations.of(context).translate('category_seastorm'),
      AppLocalizations.of(context).translate('category_snowfalls'),
      AppLocalizations.of(context).translate('category_droughts'),
      AppLocalizations.of(context).translate('category_forestfire'),
      AppLocalizations.of(context).translate('category_windstorm'),
      AppLocalizations.of(context).translate('category_other'),
      AppLocalizations.of(context).translate('category_adaptation'),
      AppLocalizations.of(context).translate('category_badpractice')];
    print(MediaQuery.of(context).padding);


    return WillPopScope(
        onWillPop: () {
          SystemNavigator.pop();
        },
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
            child: AppBar(
                backgroundColor: Colors.blue,// Color(0xff267CC8),
              title: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo_color.png',
                    width: 35, height: 35,
                  ),
                  Container(width: 15),
                  Text(
                    "floodup",
                    style: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 20,
                    ),
                  )
                ],
              ),
                leading: IconButton(
                icon: Icon(Icons.menu, color: Color(0xffffffff)),
                onPressed: () {
                  _key.currentState.openDrawer();
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: new Image.asset('assets/images/filter_icon.png', width: 20, height: 20),// Icon(Icons.filter_list, color: Color(0xffffffff)),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FilterBy(
                            filters: [AppLocalizations.of(context).translate('category_all')]..addAll(categories),
                            previous_category: selected_category,
                            onSelect: (int index) {
                              selected_category = index;
                              LoadWeatherEvents(category: selected_category);
                            },
                          );
                        }
                    );
                  },
                )
              ],
              flexibleSpace: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 52),
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  markers: Set.from(all_Event_Markers),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    map_controller = controller;
                  },
                ),
              ),
            ),
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height)
        ),
        floatingActionButton: Visibility(
          visible: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: Color(0xff267CC8),
                  child: Icon(Icons.my_location, color: Colors.white),
                  onPressed: () async {
                    map_controller.moveCamera(CameraUpdate.newLatLng(LatLng(globals.currentLocation.latitude, globals.currentLocation.longitude)));
                  },
                ),
              ),
              FloatingActionButton(
                heroTag: null,
                backgroundColor: Color(0xff267CC8),
                child: Icon(Icons.add, color: Colors.white),
                onPressed: () async {
                  if(globals.bLoggedIn){
                    bool result = await Navigator.push(
                      context,
                      MaterialPageRoute<bool>(
                        builder: (context) => Publish()
                      )
                    );
                    if (result != null) {
                      LoadWeatherEvents(category: selected_category);
                    }
                  }
                  else{
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login()
                      ),
                      (r) => r.isFirst
                    );
                  }
                },
              )
            ],
          ),
//          child: FloatingActionButton(
//            backgroundColor: Color(0xff267CC8),
//            child: Icon(Icons.add, color: Colors.white),
//            onPressed: () async {
//              if(globals.bLoggedIn){
//                bool result = await Navigator.push(
//                    context,
//                    MaterialPageRoute<bool>(
//                        builder: (context) => Publish()
//                    )
//                );
//                if (result != null) {
//                  LoadWeatherEvents(category: selected_category);
//                }
//              }
//              else{
//                Navigator.pushAndRemoveUntil(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => Login()
//                  ),
//                  (r) => r.isFirst
//                );
//              }
//            },
//          )
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo_color.png',
                      width: 65, height: 65,
                    ),
                    Container(height: 15),
                    Text(
                      'floodup',
                      style: TextStyle(
                          color: Color(0xff5DAEE0),
                          fontSize: 32,
                          fontWeight: FontWeight.w700
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.location_on, color: Color(0xffFE6E52)),
                    Container(width: 15),
                    Text(
                      AppLocalizations.of(context).translate('observation_title'),
                      style: TextStyle(
                        color: Color(0xffFE6E52),
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.insert_drive_file, color: Color(0xff787993)),
                    Container(width: 15),
                    Text(
                      AppLocalizations.of(context).translate('resource_title'),
                      style: TextStyle(
                        color: Color(0xff787993),
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Resources()
                      )
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.info_outline, color: Color(0xff787993)),
                    Container(width: 15),
                    Text(
                      AppLocalizations.of(context).translate('category_title'),
                      style: TextStyle(
                        color: Color(0xff787993),
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Categories()
                      )
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person_outline, color: Color(0xff787993)),
                    Container(width: 15),
                    Text(
                      AppLocalizations.of(context).translate('about_title'),
                      style: TextStyle(
                        color: Color(0xff787993),
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutUs()
                      )
                  );
                },
              ),
              Expanded(child: Container(),),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(globals.bLoggedIn ? Icons.exit_to_app : Icons.input, color: Color(0xff787993)),
                    Container(width: 15),
                    Text(
                      globals.bLoggedIn ? AppLocalizations.of(context).translate('logout_title') : AppLocalizations.of(context).translate('login_title'),
                      style: TextStyle(
                        color: Color(0xff787993),
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  if(globals.bLoggedIn){
                    HOWNDProgressIndicator.showProgress(context, isTransparent: true);
                    FirebaseAuth.instance.signOut().then((onvalue) {
                      HOWNDProgressIndicator.hideProgress();
                      globals.firUserId = "";
                      globals.userFullName = "";
                      globals.userEmail = "";
                      globals.isSubscribed = "No";
                      globals.isMapDisplayed = true;
                      globals.bLoggedIn = false;
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                          context,
                          //_key.currentContext,
                          MaterialPageRoute(
                              builder: (context) => Login()
                          ),
                              (r) => r.isFirst
                      );
                    });
                  }
                  else{
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                        context,
                        //_key.currentContext,
                        MaterialPageRoute(
                            builder: (context) => Login()
                        ),
                            (r) => r.isFirst
                    );
                  }
                },
              ),
              Container(height: 1, color: Color(0xffD8D8D8),),
              FlatButton(
                child: Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    alignment: Alignment.center,
                    child: Text.rich(
                      TextSpan(
                        text: '',
                        style: TextStyle(fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Floodup.ub.edu',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue
                              )),
                          // can add more TextSpans here...
                        ],
                      ),
                    )
                ),
                onPressed: () {
                  launch("http://www.floodup.ub.edu/");
                },
              ),
            ],
          ),
        ),
      ),
    );

    //return ;
  }
}


