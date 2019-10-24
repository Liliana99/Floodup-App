import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:floodup/map.dart';
import 'package:floodup/signup.dart';
import 'package:floodup/forgot.dart';
import 'package:floodup/globals.dart' as globals;
import 'package:floodup/hownd-progressindicator.dart';
import 'package:flutter/services.dart';
import 'package:floodup/AppLocalizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  Login();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _db_instance = Firestore.instance;
  GlobalKey<_LoginState> _globalKey = GlobalKey();

  TextEditingController _text_email = new TextEditingController();
  TextEditingController _text_password = new TextEditingController();
  ScrollController _loginController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loginController = ScrollController();
  }

  @override
  void dispose() {
    _loginController.dispose();
    super.dispose();
  }

  ProcessLogin()
  {
    if(_text_email.text.isEmpty){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(
                  AppLocalizations.of(context).translate('error_email_empty'),
                  //'Please input your email address.'
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

    bool emailValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_text_email.text);

    if(!emailValid){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(
                  AppLocalizations.of(context).translate('error_email_invalid'),
                  //'Please input valid email address.'
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

    if(_text_password.text.isEmpty){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(
                AppLocalizations.of(context).translate('error_password_empty'),
                  //'Please input your password.'
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

    if(_text_password.text.length < 6){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(
                  AppLocalizations.of(context).translate('error_password_invalid')
              //    'Password length should be 6 at least.'
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

    LoginToFireBase(_text_email.text, _text_password.text);
  }

  LoginToFireBase(String _email, String _password) async
  {
    HOWNDProgressIndicator.showProgress(context, isTransparent: true);

    try{
      FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;

      try{
        var subVal = await _db_instance.collection('subscriptions').document(user.email).get();
        if(subVal.exists){
          globals.isSubscribed = subVal["subscribed"];
        }
        print("subscription value = ${globals.isSubscribed}");
      }on Exception catch(error){
        print(error);
      }

      globals.firUserId = user.uid;
      if(user.displayName != null && user.displayName != ""){
        globals.userFullName = user.displayName;
      }
      globals.userEmail = user.email;
      globals.bLoggedIn = true;

      HOWNDProgressIndicator.hideProgress();

      _text_email.text = '';
      _text_password.text = '';
      _loginController.jumpTo(0);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Map()
          )
      );
    }on PlatformException catch(error){
      HOWNDProgressIndicator.hideProgress();

      String errorMessage = AppLocalizations.of(context).translate('error_login');
      switch(error.code)
      {
        case "ERROR_USER_NOT_FOUND":
          errorMessage = AppLocalizations.of(context).translate('error_email_not_found');
          //"The email address is not registered.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = AppLocalizations.of(context).translate('error_wrong_password');
          //"Invalid Credential.";
          break;
        default:
          errorMessage = AppLocalizations.of(context).translate('error_login');
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
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/login_background.png'),
              fit: BoxFit.cover
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: ListView(
                  controller: _loginController,
                  children: <Widget>[
                    Container(height: 40),
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
                      AppLocalizations.of(context).translate('welcome_title'),
//                    '¡Welcome to Floodup!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(height: 20),
                    Text(
                      AppLocalizations.of(context).translate('welcome_instruction'),
                      //'Share and explore the main impacts of natural hazards and climate change, aspects that need improvement and how communities are adapting. Your contribution is essential.',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(height: 10),
                    Form(
                      key: _globalKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _text_email,
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).translate('email_title'),
                                //'E-mail',
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
                          )
                        ],
                      ),
                    ),
                    Container(height: 20),
                    Container(
                      height: 45,
                      color: Colors.white,
                      child: FlatButton(
                          onPressed: () {
                            ProcessLogin();
                          },
                          child: Text(
                            AppLocalizations.of(context).translate('login_title'),
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16
                            ),
                          )
                      ),
                    ),
                    Container(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text(
                            AppLocalizations.of(context).translate('forgot_title'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Forgot()
                                )
                            );
                          },
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(height: 1, color: Colors.white),
                        ),
                        Container(
                            width: 80,
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context).translate('or_title'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            )
                        ),
                        Expanded(
                          child: Divider(height: 1, color: Colors.white),
                        )
                      ],
                    ),
                    Container(height: 15),
                    Container(
                      height: 45,
                      color: Colors.red,
                      child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signup()
                                )
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context).translate('register_title'),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                            ),
                          )
                      ),
                    ),
                    Container(height: 15),
                    FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Map()
                              )
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context).translate('without_register_title'),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                          ),
                        )
                    ),
                    Container(height: 10),
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}
