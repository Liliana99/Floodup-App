import 'package:flutter/material.dart';
import 'package:floodup/globals.dart' as globals;
import 'package:floodup/category_floods.dart';
import 'package:floodup/category_storms.dart';
import 'package:floodup/category_landslides.dart';
import 'package:floodup/category_seastorms.dart';
import 'package:floodup/category_snowfalls.dart';
import 'package:floodup/category_droughts.dart';
import 'package:floodup/category_forest.dart';
import 'package:floodup/category_windstorms.dart';
import 'package:floodup/category_other.dart';
import 'package:floodup/category_adaption.dart';
import 'package:floodup/category_badpractice.dart';
import 'AppLocalizations.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  Widget _listItem(int index) {

    List<String> _items = <String>[
      AppLocalizations.of(context).translate('category_floods'),
      AppLocalizations.of(context).translate('category_storm'),
      AppLocalizations.of(context).translate('category_landslide'),
      AppLocalizations.of(context).translate('category_seastorm'),
      AppLocalizations.of(context).translate('category_snowfalls'),
      AppLocalizations.of(context).translate('category_droughts'),
      AppLocalizations.of(context).translate('category_forestfire'),
      AppLocalizations.of(context).translate('category_windstorm'),
      AppLocalizations.of(context).translate('category_other'),
      AppLocalizations.of(context).translate('category_adaptation'),
      AppLocalizations.of(context).translate('category_badpractice')];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FlatButton(
          child: Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              _items[index],
              style: TextStyle(
                color: Color(0xff787993),
                fontSize: 16,
              ),
            ),
          ),
          onPressed: () {
            switch (index) {
              case 0: {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Category_floods()
                    )
                );
              }
              break;
              case 1: {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Category_storms()
                    )
                );
              }
              break;
              case 2: {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Category_landslides()
                    )
                );
              }
              break;
              case 3: {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Category_seastorms()
                    )
                );
              }
              break;
              case 4: {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Category_snowfalls()
                    )
                );
              }
              break;
              case 5: {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Category_droughts()
                    )
                );
              }
              break;
              case 6: {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Category_forest()
                    )
                );
              }
              break;
              case 7: {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Category_windstorms()
                    )
                );
              }
              break;
              case 8: {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Category_other()
                    )
                );
              }
              break;
              case 9: {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Category_adaption()
                    )
                );
              }
              break;
              case 10: {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Category_badpractice()
                    )
                );
              }
              break;
              default : {

              }
              break;
            }

          },
        ),
        Container(height: 1, color: Color(0xffD8D8D8),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> _items = <String>[
      AppLocalizations.of(context).translate('category_floods'),
      AppLocalizations.of(context).translate('category_storm'),
      AppLocalizations.of(context).translate('category_landslide'),
      AppLocalizations.of(context).translate('category_seastorm'),
      AppLocalizations.of(context).translate('category_snowfalls'),
      AppLocalizations.of(context).translate('category_droughts'),
      AppLocalizations.of(context).translate('category_forestfire'),
      AppLocalizations.of(context).translate('category_windstorm'),
      AppLocalizations.of(context).translate('category_other'),
      AppLocalizations.of(context).translate('category_adaptation'),
      AppLocalizations.of(context).translate('category_badpractice')];

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
          AppLocalizations.of(context).translate('category_title'),
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(height: 1, color: Color(0xffD8D8D8),),
              Expanded(
                child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _listItem(index);
                    }
                ),
              )
            ],
          )
      ),
    );
  }
}
