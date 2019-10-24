import 'package:flutter/material.dart';

import 'package:floodup/AppLocalizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Category_seastorms extends StatefulWidget {
  @override
  _CategorySeastormState createState() => _CategorySeastormState();
}

class _CategorySeastormState extends State<Category_seastorms> {

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
                          image: AssetImage('assets/images/category_seastorm.png'),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right:22, top: 10),
                  child: Text(
                    '',
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
                        AppLocalizations.of(context).translate('category_seastorm'),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            //fontWeight: FontWeight.w700
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('category_seastorm_desc'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),
                      Container(height: 20),
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
