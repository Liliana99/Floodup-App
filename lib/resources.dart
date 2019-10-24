import 'package:flutter/material.dart';
import 'package:floodup/resources_a.dart';
import 'package:floodup/resources_b.dart';
import 'package:floodup/resources_c.dart';
import 'package:floodup/resources_d.dart';

import 'AppLocalizations.dart';

class Resources extends StatefulWidget {
  @override
  _ResourcesState createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {

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
          AppLocalizations.of(context).translate('resource_title'),
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
              Container(height: 1, color: Color(0xffD8D8D8),),
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('resource_mnu1_title'),
                    style: TextStyle(
                      color: Color(0xff787993),
                      fontSize: 16,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Resources_a()
                      )
                  );
                },
              ),
              Container(height: 1, color: Color(0xffD8D8D8),),
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('resource_mnu2_title'),
                    style: TextStyle(
                      color: Color(0xff787993),
                      fontSize: 16,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Resources_b()
                      )
                  );
                },
              ),
              Container(height: 1, color: Color(0xffD8D8D8),),
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('resource_mnu3_title'),
                    style: TextStyle(
                      color: Color(0xff787993),
                      fontSize: 16,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Resources_c()
                      )
                  );
                },
              ),
              Container(height: 1, color: Color(0xffD8D8D8),),
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('resource_mnu4_title'),
                    style: TextStyle(
                      color: Color(0xff787993),
                      fontSize: 16,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Resources_d()
                      )
                  );
                },
              ),
              Container(height: 1, color: Color(0xffD8D8D8),)
            ],
          )
      ),
    );
  }
}
