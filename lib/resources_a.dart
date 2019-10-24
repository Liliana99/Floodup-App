import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AppLocalizations.dart';

class Resources_a extends StatefulWidget {
  @override
  _ResourcesAState createState() => _ResourcesAState();
}

class _ResourcesAState extends State<Resources_a> {

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
          AppLocalizations.of(context).translate('resource_mnu1_title'),
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textAlign: TextAlign.center,
        ),
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
                        AppLocalizations.of(context).translate('resource_mnu1_desc1'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),
                      Image.asset('assets/images/resource_a_1.png', height: MediaQuery.of(context).size.width * 0.5),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu1_desc2'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),
                      Image.asset('assets/images/resource_a_2.png', height: MediaQuery.of(context).size.width * 0.5),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu1_desc3'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),
                      Image.asset('assets/images/resource_a_3.png', height: MediaQuery.of(context).size.width * 0.5),
                      GestureDetector(
                        onTap: () {
                          launch("http://www.floodup.ub.edu/clasificacion");
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
                                  text: AppLocalizations.of(context).translate('visit_title')
                              ),
                              TextSpan(
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                    fontSize: 14,
                                    height: 1.2
                                ),
                                text: 'www.floodup.ub.edu/clasificacion',
                              ),
                              TextSpan(
                                  style: TextStyle(
                                      color: Color(0xff787993),
                                      fontSize: 14,
                                      height: 1.2
                                  ),
                                  text: AppLocalizations.of(context).translate('resource_mnu1_desc4')
                              ),
                            ],
                          ),
                        ),
                      ),


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
