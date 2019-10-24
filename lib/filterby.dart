import 'package:flutter/material.dart';

import 'package:floodup/map.dart';
import 'package:floodup/signup.dart';
import 'package:floodup/forgot.dart';

class FilterBy extends StatefulWidget {
  FilterBy({this.title = 'Filter By', this.filters, this.previous_category, this.onSelect});

  List<String> filters;
  Function(int) onSelect;
  String title;
  int previous_category;

  @override
  _FilterByState createState() => _FilterByState();
}

class _FilterByState extends State<FilterBy> {

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(30),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 65,
              child: Center(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Container(height: 1, color: Color(0xff787993),),
            Expanded(
              child: ListView.builder(
                itemCount: widget.filters.length,
                itemBuilder: (BuildContext context, int index) {
                  if(index == widget.previous_category) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        FlatButton(
                          child: new Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.filters[index],
                                  style: TextStyle(
                                    color: Color(0xff267CC8),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Image.asset(
                                'assets/images/category_selected.png',
                                height: 23.0,
                                width: 23.0//,
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.pop(context);

                            widget.onSelect(index);
                          },
                        ),

                        Container(height: 1, color: Color(0xffD8D8D8),)
                      ],
                    );
                  }
                  else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        FlatButton(
                          child: Container(
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.filters[index],
                              style: TextStyle(
                                color: Color(0xff787993),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);

                            widget.onSelect(index);
                          },
                        ),
                        Container(height: 1, color: Color(0xffD8D8D8),)
                      ],
                    );
                  }

                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
