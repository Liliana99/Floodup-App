import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:floodup/globals.dart' as globals;
import 'package:floodup/categories.dart';
import 'package:floodup/filterby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:floodup/hownd-progressindicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:geolocator/geolocator.dart';
import 'package:floodup/locationpicker.dart';
import 'package:share/share.dart';
import 'AppLocalizations.dart';
import 'package:geocoder/geocoder.dart';

class Publish extends StatefulWidget {
  @override
  _PublishState createState() => _PublishState();
}

class _PublishState extends State<Publish> {
  final _db_instance = Firestore.instance;

  bool _isHazardShow = false;
  int _category = 0;
  DateTime _createDate = DateTime.now();
  List<Image> _images = [];
  List<File> _imageFiles = [];
  List<String> _fileDownloadUrls = [];

  bool _knowAlert = false;
  int _climateRating = -1;
  int _uploadRating = -1;
  int _botherRating = -1;

  TextEditingController _text_hazard = new TextEditingController();
  TextEditingController _text_location = new TextEditingController();
  TextEditingController _text_attention = new TextEditingController();
  TextEditingController _text_information = new TextEditingController();
  TextEditingController _text_climatewhy = new TextEditingController();
  TextEditingController _text_reduceimpact = new TextEditingController();
  FocusNode _text_location_focusNode = FocusNode();

  final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('event_images');

  @override
  void initState()
  {
    super.initState();

    print('getting address....');
    _getCurAddress();
    print('next address....');
    _text_location_focusNode.addListener(() {
      if (_text_location_focusNode.hasFocus) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LocationAdd(
                onComplete: (String result){
                  _text_location.text = result;
                },
              )
          ),
        );
      }
    });
  }

  Future<void> _getCurAddress() async{
    final coordinates = new Coordinates(globals.currentLocation.latitude, globals.currentLocation.longitude);
    print('into address....');
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print('finishing address....');
    var firstAddress = addresses.first;
    _text_location.text = firstAddress.addressLine;
    print("${firstAddress.featureName} : ${firstAddress.addressLine}");
  }

  Future<void> _getImage(ImageSource type) async {
    final File image = await ImagePicker.pickImage(source: type, imageQuality: 80);
    if (image != null) {
      setState(() {
        _images.add(Image.file(image, fit: BoxFit.cover,));
        _imageFiles.add(image);
      });
    }
  }

  Widget _sheetItem({IconData iconData, String title, Function onPressed}) {
    return CupertinoActionSheetAction(
      onPressed: onPressed,
      child: Row(
        children: <Widget>[
          Container(width: 10),
          Icon(
            iconData,
            color: Colors.blue,
          ),
          Container(width: 20),
          Text(
              title
          )
        ],
      ),
    );
  }

  Widget _ratingBar(int rating, Function(int) onPressed) {
    List<Widget> widgets = [];
    widgets.add(
        SizedBox(
          width: rating >= 0 ? 15 : 15, height: rating >= 0 ? 15 : 15,
          child: FlatButton(
            padding: const EdgeInsets.all(0),
            child: Image.asset(
              rating >= 0
                  ? 'assets/images/Oval4.png'
                  : 'assets/images/Oval5.png',
              width: rating >= 0 ? 15 : 15, height: rating >= 0 ? 15 : 15,
            ),
            onPressed: () {
              onPressed(0);
            },
          ),
        )
    );
    for (int i = 1 ; i < 5 ; i++) {
      widgets.add(
          Expanded(
            child: Container(height: 1, color: rating >= i ? Color(0xff267CC8) : Color(0xffDFDFE4)),
          )
      );
      widgets.add(
          SizedBox(
            width: rating >= i ? 15 : 15, height: rating >= i ? 15 : 15,
            child: FlatButton(
              padding: const EdgeInsets.all(0),
              child: Image.asset(
                rating >= i
                    ? 'assets/images/Oval4.png'
                    : 'assets/images/Oval5.png',
                width: rating >= i ? 15 : 15, height: rating >= i ? 15 : 15,
              ),
              onPressed: () {
                onPressed(i);
              },
            ),
          )
      );
    }
    return Container(
      height: 16,
      child: Row(
        children: widgets,
      ),
    );
  }

  PublishEvent() async
  {
    if(_category == 8) {
      if(_text_hazard.text.isEmpty) {

        showDialog(context: context,
            builder: (context){
              return AlertDialog(
                content: Text(
                    AppLocalizations.of(context).translate('error_hazard_empty')
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context).translate('ok_title')),
                  )
                ],
              );
            }
        );
        return;
      }
    }

    if(_text_location.text.isEmpty){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(
                  AppLocalizations.of(context).translate('error_location_empty')
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context).translate('ok_title')),
                )
              ],
            );
          }
      );
      return;
    }

//    if(_images.length == 0){
//      showDialog(context: context,
//          builder: (context){
//            return AlertDialog(
//              content: Text(
//                  AppLocalizations.of(context).translate('error_photo_empty')
//              ),
//              actions: <Widget>[
//                FlatButton(
//                  onPressed: (){
//                    Navigator.pop(context);
//                  },
//                  child: Text(AppLocalizations.of(context).translate('ok_title')),
//                )
//              ],
//            );
//          }
//      );
//      return;
//    }

//    if(_text_attention.text.isEmpty) {
//      showDialog(context: context,
//          builder: (context){
//            return AlertDialog(
//              content: Text('Please specify what caught your attention.'),
//              actions: <Widget>[
//                FlatButton(
//                  onPressed: (){
//                    Navigator.pop(context);
//                  },
//                  child: Text(AppLocalizations.of(context).translate('ok_title')),
//                )
//              ],
//            );
//          }
//      );
//      return;
//    }

//    if(_text_information.text.isEmpty) {
//      showDialog(context: context,
//          builder: (context){
//            return AlertDialog(
//              content: Text('Please provide any information.'),
//              actions: <Widget>[
//                FlatButton(
//                  onPressed: (){
//                    Navigator.pop(context);
//                  },
//                  child: Text(AppLocalizations.of(context).translate('ok_title')),
//                )
//              ],
//            );
//          }
//      );
//      return;
//    }

//    if(_climateRating < 0) {
//      showDialog(context: context,
//          builder: (context){
//            return AlertDialog(
//              content: Text('Please choose value for the climate change.'),
//              actions: <Widget>[
//                FlatButton(
//                  onPressed: (){
//                    Navigator.pop(context);
//                  },
//                  child: Text(AppLocalizations.of(context).translate('ok_title')),
//                )
//              ],
//            );
//          }
//      );
//      return;
//    }

//    if(_text_climatewhy.text.isEmpty) {
//      showDialog(context: context,
//          builder: (context){
//            return AlertDialog(
//              content: Text('Please specify why you choose that value for the climate change.'),
//              actions: <Widget>[
//                FlatButton(
//                  onPressed: (){
//                    Navigator.pop(context);
//                  },
//                  child: Text(AppLocalizations.of(context).translate('ok_title')),
//                )
//              ],
//            );
//          }
//      );
//      return;
//    }

//    if(_uploadRating < 0){
//      showDialog(context: context,
//          builder: (context){
//            return AlertDialog(
//              content: Text('Please specify the upload rating.'),
//              actions: <Widget>[
//                FlatButton(
//                  onPressed: (){
//                    Navigator.pop(context);
//                  },
//                  child: Text(AppLocalizations.of(context).translate('ok_title')),
//                )
//              ],
//            );
//          }
//      );
//      return;
//    }

//    if(_botherRating < 0){
//      showDialog(context: context,
//          builder: (context){
//            return AlertDialog(
//              content: Text('Please specify if it bordered you.'),
//              actions: <Widget>[
//                FlatButton(
//                  onPressed: (){
//                    Navigator.pop(context);
//                  },
//                  child: Text(AppLocalizations.of(context).translate('ok_title')),
//                )
//              ],
//            );
//          }
//      );
//      return;
//    }

//    if(_text_reduceimpact.text.isEmpty) {
//      showDialog(context: context,
//          builder: (context){
//            return AlertDialog(
//              content: Text('Please input what you can do to reduce the impact of climate change.'),
//              actions: <Widget>[
//                FlatButton(
//                  onPressed: (){
//                    Navigator.pop(context);
//                  },
//                  child: Text(AppLocalizations.of(context).translate('ok_title')),
//                )
//              ],
//            );
//          }
//      );
//      return;
//    }

    final intl.DateFormat formatDate = intl.DateFormat('dd-MM-yyyy');

    HOWNDProgressIndicator.showProgress(context, isTransparent: true);

//    _db_instance.runTransaction((transaction) async{
    LatLng loc = await getLocationFromAddress(_text_location.text);

    if(loc == LatLng(0.0, 0.0)){
      await showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(
                  AppLocalizations.of(context).translate('error_location_invalid')
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context).translate('ok_title')),
                )
              ],
            );
          }
      );

      HOWNDProgressIndicator.hideProgress();
      return;
    }

    print("location = " + loc.latitude.toString() + " - " + loc.longitude.toString());

    List<String> file_arrays = [];

    if(_imageFiles.length > 0){
      file_arrays = await _uploadImages((_category + 1).toString() + '/');
    }

    try{
      await _db_instance.collection('events').add({
        'category' : (_category + 1).toString(),
        'location' : new GeoPoint(loc.latitude, loc.longitude),
        'hazard' : _text_hazard .text,
        'date' : formatDate.format(_createDate),
        'placename' : _text_location.text,
        'attention' : _text_attention.text,
        'information' : _text_information.text,
        'uploadobservation' : _knowAlert,
        'rating_climate' : _climateRating + 1,
        'rating_climate_why' : _text_climatewhy.text,
        'rating_upload' : _uploadRating + 1,
        'rating_bother' : _botherRating + 1,
        'reduce_impact' : _text_reduceimpact.text,
        'image_files' : _fileDownloadUrls,
        'publisher' : globals.userFullName,
        'status' : 1
      });
    }on Exception catch(error){
      print(error);
    }

    HOWNDProgressIndicator.hideProgress();
    bool isPublishClicked = false;
    await  Alert(
        style: AlertStyle(
            descStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontSize: 16.0)
        ),
        context: context,
        title: AppLocalizations.of(context).translate('sucess_publish_title'),
        desc: AppLocalizations.of(context).translate('sucess_publish_description'),
        image: Image.asset("assets/images/logo_color.png", width: 80, height: 80),
        buttons: [
          DialogButton(
              radius: BorderRadius.circular(3),
              child: Text(
                AppLocalizations.of(context).translate('share_title'),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                isPublishClicked = true;
                Navigator.pop(context);
              }
          )
        ]
    ).show();

    if(isPublishClicked) {

      String shareText = AppLocalizations.of(context).translate('share_text');//,"Take a look at the observation. I've just posted in Floodup App! You will be able to publish and discover meteorological events near you.\nDownload at .......";

      if(Platform.isAndroid) {
        shareText = shareText + "https://play.google.com/store/apps/details?id=edu.ub.floodup";
      }

      Share.share(shareText);
    }

    Navigator.pop(context, true);
  }

  Future<LatLng> getLocationFromAddress(String eventAddress) async {
    print(eventAddress);
    try{
      List<Placemark> placemark = await Geolocator().placemarkFromAddress(eventAddress);
      if(placemark == null){
        print("no gps position");
        return LatLng(0.0, 0.0);
      }
      else{
        print("got gps position");
        return LatLng(placemark[0].position.latitude, placemark[0].position.longitude);
      }
    }on PlatformException catch (error){
      print("error location");
      print(error);
      return LatLng(0.0, 0.0);
    }
  }

  Future<List<String>> _uploadImages(String categoryNo) async{
    int i = 1;
    _fileDownloadUrls = [];

    for(var _imageFile in _imageFiles){
      print('upload ' + i.toString());
      i ++;
      String fileName = new DateTime.now().millisecondsSinceEpoch.toString();

      print("File Storage Path = " + categoryNo + globals.firUserId + "/" + fileName);
      final StorageReference _ref = firebaseStorageRef.child(categoryNo + fileName);
      final StorageUploadTask uploadTask = _ref.putFile(_imageFile);

      String fileDownloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      print("File Download Url = " + fileDownloadUrl);
      _fileDownloadUrls.add(fileDownloadUrl);
    }

    return _fileDownloadUrls;
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
      AppLocalizations.of(context).translate('category_badpractice')
    ];

    final intl.DateFormat formatDate = intl.DateFormat('dd-MM-yyyy');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace, color: Color(0xff267CC8)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context).translate('observation_publish_title'),
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(25),
            children: <Widget>[
              Container(height: 15),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('category_choose_title'),
                          style: TextStyle(
                            color: Color(0xff267CC8),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: FlatButton(
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    categories[_category],
                                    style: TextStyle(
                                      color: Color(0xff2333333),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down, color: Color(0xff267CC8),)
                              ],
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FilterBy(
                                      title: AppLocalizations.of(context).translate('category_choose_title'),
                                      filters: categories,
                                      previous_category: _category,
                                      onSelect: (int index) {
                                        setState(() {
                                          _category = index;
                                          if(_category == 8) {
                                            _isHazardShow = true;
                                          }
                                          else{
                                            _isHazardShow = false;
                                          }
                                        });
                                      },
                                    );
                                  }
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(width: 20),
                  SizedBox(
                    width: 30, height: 30,
                    child: FlatButton(
                      padding: const EdgeInsets.all(0),
                      child: Image.asset(
                        'assets/images/question-mark.png',
                        width: 23, height: 23,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Categories()
                            )
                        );
                      },
                    ),
                  )
                ],
              ),
              Visibility(
                  visible: _isHazardShow,
                  child: Container(height: 25)
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Visibility(
                      visible: _isHazardShow,
                      child: Text(
                        AppLocalizations.of(context).translate('hazard_title'),
                        style: TextStyle(
                          color: Color(0xff267CC8),
                          fontSize: 14,
                        ),
                      )
                  ),
                  Visibility(
                      visible: _isHazardShow,
                      child: TextField(
                        controller: _text_hazard,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xff267CC8), width: 1.0),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xff267CC8), width: 1.0),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16
                        ),
                      )
                  )
                ],
              ),
              Container(height: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('date_title'),
                    style: TextStyle(
                      color: Color(0xff267CC8),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: FlatButton(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            formatDate.format(_createDate),
                            style: TextStyle(
                              color: Color(0xff2333333),
                              fontSize: 16,
                            ),
                          ),
                          Container(width: 5),
                          Icon(Icons.keyboard_arrow_down, color: Color(0xff267CC8),)
                        ],
                      ),
                      onPressed: () {
                        DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            onChanged: (DateTime date) {
                              setState(() {
                                _createDate = date;
                              });
                            },
                            onConfirm: (DateTime date) {
                              setState(() {
                                _createDate = date;
                              });
                            },
                            locale: LocaleType.en
                        );
                      },
                    ),
                  )
                ],
              ),
              Container(height: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('location_title'),
                        style: TextStyle(
                          color: Color(0xff267CC8),
                          fontSize: 14,
                        ),
                      ),
                      Container(width: 10),
                      Icon(Icons.location_on, color: Color(0xffFE6E52), size: 15,)
                    ],
                  ),
                  TextField(
                    focusNode: _text_location_focusNode,
                    controller: _text_location,
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff267CC8), width: 1.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff267CC8), width: 1.0),
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                    ),
                  )
                ],
              ),
              Container(height: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('photo_upload_instruction'),
                    style: TextStyle(
                      color: Color(0xff267CC8),
                      fontSize: 14,
                    ),
                  ),
                  Container(height: 15),
                  GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(
                      min(_images.length + 1, 4),
                      (int index) {

                          if (index < _images.length) {
                            return _images[index];
                          }

                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffD5D6D7)),
                            ),
                            child: FlatButton(
                              child: Image.asset('assets/images/Add.png', width: 33, height: 33),
                              onPressed: () {
                                //_getImage();
                                showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          CupertinoActionSheet(
                                            cancelButton: CupertinoActionSheetAction(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              isDefaultAction: true,
                                              child: Text(
                                                  AppLocalizations.of(context).translate('cancel_title')
                                              ),
                                            ),
                                            actions: <Widget>[
                                              _sheetItem(
                                                  iconData: Icons.camera_alt,
                                                  title: AppLocalizations.of(context).translate('photo_camera'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _getImage(ImageSource.camera);
                                                  }
                                              ),
                                              _sheetItem(
                                                  iconData: Icons.photo,
                                                  title: AppLocalizations.of(context).translate('photo_gallery'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _getImage(ImageSource.gallery);
                                                  }
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    }
                                );
                              },
                            ),
                          );

                      }
                    ),
                  )
                ],
              ),
              Container(height: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('caught_title'),
                    style: TextStyle(
                      color: Color(0xff267CC8),
                      fontSize: 14,
                    ),
                  ),
                  TextField(
                    controller: _text_attention,
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff267CC8), width: 1.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff267CC8), width: 1.0),
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                    ),
                  )
                ],
              ),
              Container(height: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('information_title'),
                    style: TextStyle(
                      color: Color(0xff267CC8),
                      fontSize: 14,
                    ),
                  ),
                  TextField(
                    controller: _text_information,
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff267CC8), width: 1.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff267CC8), width: 1.0),
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                    ),
                  )
                ],
              ),
              Container(height: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('upload_option_title'),
                    style: TextStyle(
                      color: Color(0xff267CC8),
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        child: Row(
                          children: <Widget>[
                            IconTheme(
                              data: new IconThemeData(
                                  color: _knowAlert ? Colors.blue : Colors.grey),
                              child: new Icon(_knowAlert ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                            ),
                            Container(width: 10),
                            Text(
                              AppLocalizations.of(context).translate('yes_title'),
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            _knowAlert = true;
                          });
                        },
                      ),
                      Container(width: 50),
                      FlatButton(
                        child: Row(
                          children: <Widget>[
                            IconTheme(
                              data: new IconThemeData(
                                  color: !_knowAlert ? Colors.blue : Colors.grey),
                              child: new Icon(!_knowAlert ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                            ),
                            Container(width: 10),
                            Text(
                              AppLocalizations.of(context).translate('no_title'),
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            _knowAlert = false;
                          });
                        },
                      )
                    ],
                  )
                ],
              ),
              Container(height: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('climate_rating_title'),
                    style: TextStyle(
                      color: Color(0xff267CC8),
                      fontSize: 14,
                    ),
                  ),
                  Container(height: 10),
                  Text(
                    AppLocalizations.of(context).translate('climate_rating_description'),
                    style: TextStyle(
                      color: Color(0xff666666),
                      fontSize: 10,
                    ),
                  ),
                  Container(height: 20),
                  _ratingBar(_climateRating, (int rating) {
                    setState(() {
                      _climateRating = rating;
                    });
                  })
                ],
              ),
              Container(height: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('why_title'),
                    style: TextStyle(
                      color: Color(0xff267CC8),
                      fontSize: 14,
                    ),
                  ),
                  TextField(
                    controller: _text_climatewhy,
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff267CC8), width: 1.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff267CC8), width: 1.0),
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                    ),
                  )
                ],
              ),
              Container(height: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('upload_rating_title'),
                    style: TextStyle(
                      color: Color(0xff267CC8),
                      fontSize: 14,
                    ),
                  ),
                  Container(height: 10),
                  Text(
                    AppLocalizations.of(context).translate('upload_rating_description'),
                    style: TextStyle(
                      color: Color(0xff666666),
                      fontSize: 10,
                    ),
                  ),
                  Container(height: 20),
                  _ratingBar(_uploadRating, (int rating) {
                    setState(() {
                      _uploadRating = rating;
                    });
                  })
                ],
              ),
              Container(height: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('bother_rating_title'),
                    style: TextStyle(
                      color: Color(0xff267CC8),
                      fontSize: 14,
                    ),
                  ),
                  Container(height: 10),
                  Text(
                    AppLocalizations.of(context).translate('bother_rating_description'),
                    style: TextStyle(
                      color: Color(0xff666666),
                      fontSize: 10,
                    ),
                  ),
                  Container(height: 20),
                  _ratingBar(_botherRating, (int rating) {
                    setState(() {
                      _botherRating = rating;
                    });
                  })
                ],
              ),
              Container(height: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('reduce_impact_title'),
                    style: TextStyle(
                      color: Color(0xff267CC8),
                      fontSize: 14,
                    ),
                  ),
                  TextField(
                    controller: _text_reduceimpact,
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff267CC8), width: 1.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff267CC8), width: 1.0),
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                    ),
                  )
                ],
              ),
              Container(height: 25),
              Container(
                height: 45,
                color: Color(0xff267CC8),
                child: FlatButton(
                    onPressed: () {
                      PublishEvent();
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('publish_title'),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                      ),
                    )
                ),
              ),
              Container(height: 25),
            ],
          )
      ),
    );
  }
}
