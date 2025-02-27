import 'dart:async';

import 'package:location/location.dart';

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({this.latitude, this.longitude});
}

class LocationService {
  UserLocation _currentLocation;
  var location = Location();

  StreamController<UserLocation> _locationController = StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService(){
    location.requestPermission().then((granted){
      if(granted){
        location.onLocationChanged().listen((locationData){
          if(locationData != null){
            _locationController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude
            ));
          }
        });
      }
    });
  }

  Future<UserLocation> geoLocation() async{
    try{
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch(e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }


}