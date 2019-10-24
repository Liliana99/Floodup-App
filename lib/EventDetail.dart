import 'dart:math';
import 'package:flutter/material.dart';

import 'package:floodup/LinkTextSpan.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'AppLocalizations.dart';

class EventDetail extends StatefulWidget {
  EventDetail({
    this.images,
    this.publisherName,
    this.eventCategory,
    this.eventDate,
    this.eventLocation,
    this.caughtAttention,
    this.informationData,
    this.isUpload,
    this.climateRating,
    this.why,
    this.uploadRating,
    this.botherRating,
    this.reduceImpact
  });

  List<String> images;
  String publisherName;
  String eventCategory;
  String eventDate;
  String eventLocation;
  String caughtAttention;
  String informationData;
  bool isUpload;
  int climateRating;
  String why;
  int uploadRating;
  int botherRating;
  String reduceImpact;

  //Function(String) onComplete;

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {

  final PageController _controller = PageController(initialPage: 0, viewportFraction: 1);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _currentIndex = _controller.page.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.caughtAttention == ""){
      widget.caughtAttention = "-";
    }

    if(widget.informationData == ""){
      widget.informationData = "-";
    }

    String isUploadText = AppLocalizations.of(context).translate('yes_title');
    if(widget.isUpload) {
      isUploadText = AppLocalizations.of(context).translate('no_title');
    }

    String climateRatingText = "-";
    if(widget.climateRating > 0){
      climateRatingText = widget.climateRating.toString();
    }

    String uploadRatingText = "-";
    if(widget.uploadRating > 0){
      uploadRatingText = widget.uploadRating.toString();
    }

    String botherRatingText = "-";
    if(widget.botherRating > 0){
      botherRatingText = widget.botherRating.toString();
    }

    if(widget.why == ""){
      widget.why = "-";
    }

    if(widget.reduceImpact == ""){
      widget.reduceImpact = "-";
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                Visibility(
                  visible: widget.images.length > 0 ? true : false,
                  child: Container(
                    height: 300,
                    child: Stack(
                      children: <Widget>[
                        PageView.builder(
                          physics: new AlwaysScrollableScrollPhysics(),
                          controller: _controller,
                          itemCount: widget.images.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: CachedNetworkImage(
                                imageUrl: widget.images[index],
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PhotoView(
                                      imageProvider: CachedNetworkImageProvider(
                                          widget.images[index]
                                      ),
                                    );
                                  }
                                );
                              },
                            );
                          },
                        ),
                        Positioned(
                          left: 0, right: 0, bottom: 15,
                          child: Container(
                            alignment: Alignment.center,
                            child: DotsIndicator(
                              dotsCount: max(widget.images.length, 1),
                              position: _currentIndex,
                              decorator: DotsDecorator(
                                  color: Colors.grey,
                                  activeColor: Colors.blue
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:22, top: widget.images.length > 0 ? 10 : 80),
                  child: Row(
                    children: <Widget>[
                      Text(
                          AppLocalizations.of(context).translate('publish_by_title'),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left
                      ),
                      Text(
                          widget.publisherName,
                          style: TextStyle(
                            color: Color(0xff2196f3),
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.left
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left:22, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        widget.eventCategory,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          //fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        widget.eventDate,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          //fontWeight: FontWeight.w700
                        ),
                      ),
                      Container(
                        height: 20,
                      ),

                      Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/event_mark.png',
                            width: 18, height: 18,
                          ),
                          Container(width: 8),
                          Expanded(
                            child: Text(
                              widget.eventLocation,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                          )
                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.only(top:20, right: 22.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate('caught_title'),
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                            Text(
                              widget.caughtAttention,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.only(top:20, right: 22.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate('information_title'),
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                            Text(
                              widget.informationData,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                          ],
                        ),
                      ),


                      Container(
                        padding: const EdgeInsets.only(top:20, right: 22.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate('upload_option_title'),
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                            Text(
                              isUploadText,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                          ],
                        ),
                      ),


                      Container(
                        padding: const EdgeInsets.only(top:20, right: 22.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate('climate_rating_title'),
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                            Text(
                              climateRatingText,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                          ],
                        ),
                      ),


                      Container(
                        padding: const EdgeInsets.only(top:20, right: 22.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate('why_title'),
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                            Text(
                              widget.why,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                          ],
                        ),
                      ),


                      Container(
                        padding: const EdgeInsets.only(top:20, right: 22.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate('upload_rating_title'),
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                            Text(
                              uploadRatingText,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                          ],
                        ),
                      ),


                      Container(
                        padding: const EdgeInsets.only(top:20, right: 22.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate('bother_rating_title'),
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                            Text(
                              botherRatingText,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                          ],
                        ),
                      ),



                      Container(
                        padding: const EdgeInsets.only(top:20, right: 22.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate('reduce_impact_title'),
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                            Text(
                              widget.reduceImpact,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  height: 1.2
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 30,
                )
              ]
          ),
          Positioned(
            left: 15, top: MediaQuery.of(context).padding.top,
            child: IconButton(
                icon: Icon(Icons.keyboard_backspace, color: widget.images.length > 0 ? Colors.white : Colors.black),
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
