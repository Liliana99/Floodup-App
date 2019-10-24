import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AppLocalizations.dart';

class Resources_b extends StatefulWidget {
  @override
  _ResourcesBState createState() => _ResourcesBState();
}

class _ResourcesBState extends State<Resources_b> {

  @override
  void initState() {
    super.initState();
  }

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
          AppLocalizations.of(context).translate('resource_mnu2_title'),
          style: TextStyle(
              backgroundColor: Colors.transparent,
              color: Colors.black,
              fontSize: 20.0
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
        actions: <Widget>[
          Container(width: 48)
        ],
      ),
      body: Stack(
        children: <Widget>[
          ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu2_1_title'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu2_1_desc'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),
                      Container(height: 20),
                      Image.asset('assets/images/resource_b_1.png'),
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu2_2_title'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu2_2_desc'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),
                      Container(height: 20),
                      Image.asset('assets/images/resource_b_2.png'),
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu2_3_title'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu2_3_desc'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),
                      Container(height: 20),
                      GestureDetector(
                        onTap: () {
                          launch("http://www.floodup.ub.edu/leyendo-el-futuro/");
                        },
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  style: TextStyle(
                                      color: Color(0xff787993),
                                      fontSize: 14,
                                      height: 1.2
                                  ),
                                  text: AppLocalizations.of(context).translate('resource_mnu2_more_desc')
                              ),
                              TextSpan(
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                    fontSize: 14,
                                    height: 1.2
                                ),
                                text: 'www.floodup.ub.edu/leyendo-el-futuro/',
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(height: 20),
                      Image.asset('assets/images/resource_b_3.png'),
                      Container(height: 100)
                    ],
                  ),
                ),
              ]
          )
        ],
      ),
    );
  }
}
