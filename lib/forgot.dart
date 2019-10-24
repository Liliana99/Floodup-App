import 'package:flutter/material.dart';
import 'package:floodup/hownd-progressindicator.dart';
import 'package:floodup/privacy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:floodup/hownd-progressindicator.dart';
import 'AppLocalizations.dart';

class Forgot extends StatefulWidget {

  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {

  TextEditingController _text_email = new TextEditingController();
  GlobalKey<_ForgotState> _globalKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  ProcessResetPassword()
  {
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

    resetPassword(_text_email.text);
  }

  @override
  Future<void> resetPassword(String email) async {
    HOWNDProgressIndicator.showProgress(context, isTransparent: true);
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      HOWNDProgressIndicator.hideProgress();
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              content: Text(AppLocalizations.of(context).translate('sucess_reset_password')),
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
    } on PlatformException catch(error){
      HOWNDProgressIndicator.hideProgress();
      String errorMessage = AppLocalizations.of(context).translate('error_reset_password');

      switch (error.code)
      {
        case "ERROR_USER_NOT_FOUND":
          errorMessage = AppLocalizations.of(context).translate('error_email_not_found');
          break;
        default:
          errorMessage = AppLocalizations.of(context).translate('error_reset_password');
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
                  Container(height: 10),
                  Text(
                    AppLocalizations.of(context).translate('forgot_title'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  Container(height: 20),
                  Text(
                    AppLocalizations.of(context).translate('forgot_instruction'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                    ),
                  ),
                  Container(height: 60),
                  Form(
                    key: _globalKey,
                    child: Column(
                      children: <Widget>[
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
                      ],
                    ),
                  ),
                  Container(height: 20),
                  Container(
                    height: 45,
                    color: Colors.white,
                    child: FlatButton(
                        onPressed: () {
                          ProcessResetPassword();
                        },
                        child: Text(
                          AppLocalizations.of(context).translate('send_title'),
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
