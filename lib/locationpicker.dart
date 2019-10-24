import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:google_maps_webservice/places.dart';

class LocationAdd extends StatefulWidget {
  LocationAdd({this.location = '', this.onComplete});

  String location;
  Function(String) onComplete;

  @override
  State<StatefulWidget> createState() {
    return AttendantsEditState();
  }
}

class AttendantsEditState extends State<LocationAdd> {
  TextEditingController _textEditingController;
  final GoogleMapsPlaces _placeManager = GoogleMapsPlaces(apiKey: 'AIzaSyDnt3CEyQzFlwtoAgdQAas9d_hijYvuRS4');

  @override
  void initState() {
    _textEditingController = TextEditingController(text: widget.location);

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: TextField(
          autofocus: false,
          controller: _textEditingController,
          decoration: InputDecoration(
              hintText: 'Input your location here...',
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
          style: const TextStyle(fontSize: 16),
          cursorColor: Colors.black,
          cursorWidth: 1,
          onChanged: (String text) {
            setState(() {

            });
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: FutureBuilder<PlacesAutocompleteResponse>(
            future: _placeManager.autocomplete(_textEditingController.text),
            builder: (BuildContext context, AsyncSnapshot<PlacesAutocompleteResponse> data) {
              print(data.connectionState);
              if (!data.hasData)
                return Container();

              return ListView.builder(
                  itemCount: data.data.predictions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FlatButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            data.data.predictions[index].description,
                            style: const TextStyle(
                                fontSize: 16
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      onPressed: () {
                        if (widget.onComplete != null)
                          widget.onComplete(data.data.predictions[index].description);
                        Navigator.pop(context);
                      },
                    );
                  }
              );
            }
        ),
      ),
    );
  }
}