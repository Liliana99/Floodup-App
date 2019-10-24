import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:floodup/hownd-activityindicator.dart';

class HOWNDProgressIndicator {
  static BuildContext mcontext;
  static Timer processingTimer;

  static void startProcessTimer(BuildContext context, String merchantName) {
    mcontext = context;

    if (processingTimer != null) {
      processingTimer.cancel();
    }

//    showProcessingPayment(mcontext,
//        merchantName: merchantName, isFirstStep: false, step: 0);
//    processingTimer = Timer(Duration(seconds: 3), () {
//      hideProgress();
//      showProcessingPayment(mcontext, isFirstStep: false, step: 1);
//      processingTimer.cancel();
//      processingTimer = Timer(Duration(seconds: 5), () {
//        hideProgress();
//        showProcessingPayment(mcontext, isFirstStep: false, step: 2);
//        processingTimer.cancel();
//        processingTimer = Timer(Duration(seconds: 7), () {
//          hideProgress();
//          showProcessingPayment(mcontext, isFirstStep: false, step: 3);
//          processingTimer.cancel();
//        });
//      });
//    });
  }

  static void endProcessTimer() {
    if (processingTimer != null) {
      processingTimer.cancel();
    }
    hideProgress(isPayment: true);
  }

  static void showProgress(BuildContext context,
  {String description = "", isTransparent = false}) {
    mcontext = context;

    var bodyProgress = new Scaffold(
      backgroundColor: Colors.transparent,
      body: new Stack(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.all(0),
            color: !isTransparent
                ? Colors.white.withOpacity(0.8)
                : Colors.transparent,
          ),
          new Container(
            alignment: AlignmentDirectional.center,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HOWNDActivityIndicator(
                  animating: true,
                  radius: 19,
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: new Center(
                    child: new Text(
                      description,
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Builder(
            builder: (BuildContext context) {
              return bodyProgress;
            }
        );
      },
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: (context, animation, secondAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
    );
  }

//  static void showProcessingPayment(BuildContext context,
//      {bool isFirstStep = true, String merchantName = "", int step = 0}) {
//    mcontext = context;
////    Screen.keepOn(true);
//    String message = "";
//    if (!isFirstStep) {
//      if (step == 0) {
//        message = allTranslations.text('processing2_connecting') +
//            merchantName +
//            "...";
//      } else if (step == 1) {
//        message = allTranslations.text('processing2_generating');
//      } else if (step == 2) {
//        message = allTranslations.text('processing2_activating');
//      } else {
//        message = allTranslations.text('processing2_hangon');
//      }
//    }

//    var bodyProgress = new Scaffold(
//      backgroundColor: Colors.transparent,
//      body: new Stack(
//        children: <Widget>[
//          new Container(
//            margin: const EdgeInsets.all(0),
//            color: Color.fromRGBO(48, 54, 89, 0.75),
//          ),
//          new Container(
//            alignment: AlignmentDirectional.center,
//            child: new Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                new Container(
//                  decoration: new BoxDecoration(
//                      color: Color.fromRGBO(238, 234, 234, 0.03),
//                      borderRadius: new BorderRadius.circular(5.0)),
//                  width: 88.0,
//                  height: 88.0,
//                  alignment: AlignmentDirectional.center,
//                  child: new Stack(
//                    children: <Widget>[
//                      new Center(
//                        child: new Container(
//                          width: 75.0,
//                          height: 75.0,
//                          decoration: new BoxDecoration(
//                            color: Colors.transparent,
//                            shape: BoxShape.circle,
//                            border: new Border.all(
//                              color: Colors.white,
//                              width: 6,
//                            ),
//                          ),
//                        ),
//                      ),
//                      new Center(
//                        child: new SizedBox(
//                          height: 70.0,
//                          width: 70.0,
//                          child: new CircularProgressIndicator(
//                            value: null,
//                            strokeWidth: 7.0,
//                            backgroundColor: Colors.white,
//                            valueColor: new AlwaysStoppedAnimation<Color>(
//                                Color(0xff00acff)),
//                          ),
//                        ),
//                      ),
//                      new Center(
//                        child: HOWNDView.sizedImage(
//                            34, 34, 'assets/images/progress_c.png'),
//                      ),
//                    ],
//                  ),
//                ),
//                new Container(
//                  margin: const EdgeInsets.only(top: 20.0),
//                  child: new Center(
//                    child: Padding(
//                      padding: new EdgeInsets.only(left: 20, right: 20),
//                      child: new Text(
//                        allTranslations.text("purchase_message"),
//                        textAlign: TextAlign.center,
//                        style: new TextStyle(
//                          color: Colors.white,
//                          fontSize: 16,
//                          fontWeight: FontWeight.w400,
//                        ),
//                      ),
//                    ),
//                  ),
//                )
//              ],
//            ),
//          ),
//          new Container(
//            alignment: AlignmentDirectional.center,
//            child: new Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                new Container(height: 59),
//                HOWNDView.sizedImage(
//                    50,
//                    18,
//                    isFirstStep
//                        ? 'assets/images/white_outlined_circle_progress_bar.png'
//                        : 'assets/images/blue_progress_bar.png'),
//                new Container(height: 66),
//                Padding(
//                  padding: new EdgeInsets.only(left: 20, right: 20),
//                  child: new Text(
//                      isFirstStep
//                          ? allTranslations.text('processing1_processing')
//                          : message,
//                      textAlign: TextAlign.center,
//                      style: const TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.w600,
//                          fontFamily: "Muli",
//                          fontStyle: FontStyle.normal,
//                          fontSize: 20.0)),
//                )
//              ],
//            ),
//          )
//        ],
//      ),
//    );
//
//    showDialog(
//        context: context,
//        builder: (_) => new WillPopScope(
//              onWillPop: () async => false,
//              child: bodyProgress,
//            ));
//  }

  static void hideProgress({bool isPayment = false}) {
    if (!isPayment) {
//      Screen.keepOn(false);
    }
    if (mcontext != null) {
      if (Navigator.canPop(mcontext)) {
        Navigator.pop(mcontext);
      }
    }
  }
}
