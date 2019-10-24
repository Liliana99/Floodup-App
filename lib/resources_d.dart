import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AppLocalizations.dart';

class Resources_d extends StatefulWidget {
  @override
  _ResourcesDState createState() => _ResourcesDState();
}

class _ResourcesDState extends State<Resources_d> {

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
                          image: AssetImage('assets/images/resource_d_1.png'),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right:22, top: 10),
                  child: Text(
                      '${AppLocalizations.of(context).translate('photo_title')}M. Cortès',
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
                        AppLocalizations.of(context).translate('resource_mnu4_title'),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          //fontWeight: FontWeight.w700
                        ),
                      ),
                      Container(height: 40),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu4_1_title'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu4_1_desc'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),
                      Container(height: 20),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                      color: Color(0xffF1F1F1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu4_2_title'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 18,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu4_2_1_title'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu4_2_1_desc'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu4_2_2_title'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu4_2_2_desc'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),

                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu4_2_3_title'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).translate('resource_mnu4_2_3_desc'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          launch("http://interior.gencat.cat/en/arees_dactuacio/proteccio_civil/consells_autoproteccio_emergencia/riscos_naturals/index.html");
                        },
                        child: Text.rich(
                          TextSpan(
                              text: 'http://interior.gencat.cat/en/arees_dactuacio/proteccio_civil/consells_autoproteccio_emergencia/riscos_naturals/index.html',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                                fontSize: 14,
                                height: 1.2,
                              )
                          ),
                        ),
                      ),

                      Container(height: 80),
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
