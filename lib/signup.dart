import 'dart:core';
import 'dart:core' as prefix0;

import 'package:flutter/material.dart';

import 'package:floodup/privacy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floodup/map.dart';
import 'package:floodup/globals.dart' as globals;
import 'package:floodup/hownd-progressindicator.dart';
import 'package:flutter/services.dart';
import 'AppLocalizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup extends StatefulWidget {
  Signup();

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _db_instance = Firestore.instance;
  GlobalKey<_SignupState> _globalKey = GlobalKey();

  bool _is_Read_Privacy = false;
  bool _is_subscribed = false;

  TextEditingController _text_email = new TextEditingController();
  TextEditingController _text_password = new TextEditingController();
  TextEditingController _text_con_password = new TextEditingController();
  TextEditingController _text_name = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  ProcessSignUp() {

    if(_text_name.text.isEmpty){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(
                  AppLocalizations.of(context).translate('error_name_empty')
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

    if(_text_email.text.isEmpty){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(AppLocalizations.of(context).translate('error_email_empty')),
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

    bool emailValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_text_email.text);

    if(!emailValid){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(AppLocalizations.of(context).translate('error_email_invalid')),
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

    if(_text_password.text.isEmpty){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(AppLocalizations.of(context).translate('error_password_empty')),
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

    if(_text_password.text.length < 6){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(AppLocalizations.of(context).translate('error_password_invalid')),
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

    if(_text_con_password.text.isEmpty){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(AppLocalizations.of(context).translate('error_conpassword_empty')),
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

    if(_text_con_password.text != _text_password.text){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(AppLocalizations.of(context).translate('error_password_notmatch')),
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

    if(!_is_Read_Privacy) {
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(AppLocalizations.of(context).translate('error_privacy_empty')),
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

    RegisterUserToFireBase(_text_email.text, _text_password.text, _text_name.text, _is_subscribed ? "Yes" : "No");
  }

  RegisterUserToFireBase(String _email, String _password, String _userName, String isSubscribed ) async
  {
    HOWNDProgressIndicator.showProgress(context, isTransparent: true);
    try{
      FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password)).user;

      UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
      userUpdateInfo.displayName = _userName;


      user.updateProfile(userUpdateInfo).then((onValue) async{

      try{
        await _db_instance.collection('subscriptions').document(user.email).setData({
          "subscribed" : isSubscribed
        });
        globals.isSubscribed = isSubscribed;
        print("subscription value = ${globals.isSubscribed}");
      }on Exception catch(error){
        print(error);
      }

        HOWNDProgressIndicator.hideProgress();
        globals.firUserId = user.uid;
        if(user.displayName != null && user.displayName != ""){
          globals.userFullName = user.displayName;
        }
        globals.userEmail = user.email;
        globals.bLoggedIn = true;


        await showDialog(context: context,
            builder: (context){
              return AlertDialog(
                content: Text(AppLocalizations.of(context).translate('sucess_registration')),
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

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Map()
          )
        );
      });
    }on PlatformException catch(error){
      HOWNDProgressIndicator.hideProgress();

      String errorMessage = AppLocalizations.of(context).translate('error_registration');
      switch(error.code)
      {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = AppLocalizations.of(context).translate('error_email_exist');
          break;
        case "ERROR_WEAK_PASSWORD":
          errorMessage = AppLocalizations.of(context).translate('error_password_weak');
          break;
        default:
          errorMessage = AppLocalizations.of(context).translate('error_registration');
          break;
      }

      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(errorMessage),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/register_background.png'),
            fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/logo.png',
                        width: 70, height: 70,
                      )
                    ],
                  ),
                  Container(height: 20),
                  Text(
                    AppLocalizations.of(context).translate('register_title'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(height: 40),
                  Form(
                    key: _globalKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _text_name,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).translate('fullname_title'),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white, width: 1.0),
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              )
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                          ),
                        ),
                        TextFormField(
                          controller: _text_email,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).translate('email_title'),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white, width: 1.0),
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              )
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                          ),
                        ),
                        TextFormField(
                          controller: _text_password,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).translate('password_title'),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white, width: 1.0),
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              )
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                          ),
                          obscureText: true,
                        ),
                        TextFormField(
                          controller: _text_con_password,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).translate('password_confirm_title'),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white, width: 1.0),
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              )
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                          ),
                          obscureText: true,
                        )
                      ],
                    ),
                  ),
                  Container(height: 15),
                  Row(
                    children: <Widget>[
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Checkbox(
                          value: _is_Read_Privacy,
                          onChanged: (bool value) {
                            setState(() {
                              _is_Read_Privacy = value;
                            });
                          },
                        )
                      ),
                      Text(
                        AppLocalizations.of(context).translate('privacy_instruction'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        child: Text(
                          AppLocalizations.of(context).translate('privacy_title'),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              decoration: TextDecoration.underline
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Privacy()
                              )
                          );
                        },
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            value: _is_subscribed,
                            onChanged: (bool value) {
                              setState(() {
                                _is_subscribed = value;
                              });
                            },
                          )
                      ),
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context).translate('subscription_title'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),

                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          textAlign: TextAlign.left,
                        ),
                      ),

                    ],
                  ),
                  Container(height: 15),
                  Container(
                    height: 45,
                    color: Colors.white,
                    child: FlatButton(
                        onPressed: () {
                          ProcessSignUp();
                        },
                        child: Text(
                          AppLocalizations.of(context).translate('register_title'),
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16
                          ),
                        )
                    ),
                  ),
                  Container(height: 20),
                ],
              ),
            )
        ),
      ),
    );
  }
}
