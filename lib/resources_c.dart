import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AppLocalizations.dart';

class Resources_c extends StatefulWidget {
  @override
  _ResourcesCState createState() => _ResourcesCState();
}

class _ResourcesCState extends State<Resources_c> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                Container(
                  height: 320,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/resource_c_1.png'),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right:22, top: 10),
                  child: Text(
                    '${AppLocalizations.of(context).translate('photo_title')}GAMA',
                    style: TextStyle(
                        color: Color(0xff2196f3),
                        fontSize: 14,
                    ),
                    textAlign: TextAlign.right
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(height: 7),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu3_title'),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            //fontWeight: FontWeight.w700
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu3_desc'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).translate('moreinfo_desc'),
                            style: TextStyle(
                                color: Color(0xff787993),
                                fontSize: 14,
                                height: 1.2
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              launch("http://www.floodup.ub.edu/");
                            },
                            child: Text.rich(
                              TextSpan(
                                  text: 'www.floodup.ub.edu',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                    fontSize: 14,
                                    height: 1.2,
                                  )
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ]
          ),
          Positioned(
            left: 15, top: MediaQuery.of(context).padding.top,
            child: IconButton(
                icon: Icon(Icons.keyboard_backspace, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
          )
        ],
      ),
    );
  }
}
