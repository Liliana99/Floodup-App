import 'package:flutter/material.dart';
import 'AppLocalizations.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

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
                          image: AssetImage('assets/images/aboutus_background.png'),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/images/logo.png', width: 80, height: 80,),
                      Container(height: 15),
                      Text(
                        AppLocalizations.of(context).translate('about_title'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset('assets/images/conversation.png', width: 43, height: 43,)
                        ],
                      ),
                      Container(height: 7),
                      Text(
                        AppLocalizations.of(context).translate('about_1_title'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('about_1_desc'),
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
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Color(0xffF1F1F1),
                    border: Border.all(color: Color(0xff919191))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset('assets/images/group.png', width: 43, height: 43,)
                        ],
                      ),
                      Container(height: 7),
                      Text(
                        AppLocalizations.of(context).translate('about_2_title'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('about_2_desc'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          launch("http://gamariesgos.wordpress.com");
                        },
                        child: Text.rich(
                          TextSpan(
                            text: '',
                            style: TextStyle(fontSize: 14, height: 1.2),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'http://gamariesgos.wordpress.com',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(height: 40),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('about_3_title'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        AppLocalizations.of(context).translate('about_3_desc'),
                        style: TextStyle(
                            color: Color(0xff787993),
                            fontSize: 14,
                            height: 1.2
                        ),
                      ),
                      Container(height: 40),
                      Image.asset('assets/images/about_logos.png'),
//                      Image.asset('assets/images/aboutus_logo2.png', height: 40),
//                      Container(height: 12),
//                      Image.asset('assets/images/aboutus_logo3.png', height: 37),
                      Container(height: 72),
                    ],
                  ),
                )
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
