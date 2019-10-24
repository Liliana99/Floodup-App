import 'package:flutter/material.dart';

import 'package:dots_indicator/dots_indicator.dart';

class Article extends StatefulWidget {
  Article();

  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {

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
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              decoration: new BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    Container(
                      height: 300,
                      child: Stack(
                        children: <Widget>[
                          PageView.builder(
                            physics: new AlwaysScrollableScrollPhysics(),
                            controller: _controller,
                            itemCount: 2,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/images/download.jpeg'),
                                        fit: BoxFit.cover
                                    )
                                ),
                              );
                            },
                          ),
                          Positioned(
                            left: 0, right: 0, bottom: 15,
                            child: Container(
                              alignment: Alignment.center,
                              child: DotsIndicator(
                                dotsCount: 2,
                                position: _currentIndex,
                                decorator: DotsDecorator(
                                    color: Colors.grey,
                                    activeColor: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            'Photo: Ares',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16
                            ),
                            textAlign: TextAlign.end,
                          ),
                          Container(height: 25),
                          Text(
                            'Storms/Lightning/Hailstone',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 35
                            ),
                          ),
                          Container(height: 25),
                          Text(
                            'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn\'t anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.',
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                                height: 1.1
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
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
        )
    );
  }
}
