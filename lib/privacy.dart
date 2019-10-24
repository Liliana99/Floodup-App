import 'package:flutter/material.dart';

import 'AppLocalizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {

  @override
  Widget build(BuildContext context) {
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
          AppLocalizations.of(context).translate('privacy_title'),
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Divider(color: Colors.grey,),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: Text(
                        AppLocalizations.of(context).translate('privacy_content'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          launch("http://www.floodup.ub.edu/");
                        },
                        child: Text.rich(
                          TextSpan(
                            text: '',
                            style: TextStyle(fontSize: 14, height: 1.2),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'www.floodup.ub.edu',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}
