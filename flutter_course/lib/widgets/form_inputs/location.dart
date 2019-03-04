import 'package:flutter/material.dart';
//import 'package:map_view/map_view.dart';
import '../helpers/ensure-visible.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/location_data.dart';
import '../../models/product.dart';
import 'package:location/location.dart' as geoloc;
import 'dart:async';
import '../../shared/global_config.dart';

class LocationInput extends StatefulWidget{
  final Function setLocation;
  final Product product;

  LocationInput(this.setLocation, this.product);

  @override
  State<StatefulWidget> createState() {
    
    return _LocationInputState();
  }  
}

class _LocationInputState extends State<LocationInput>{
  Uri _staticMapUri;
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();
  LocationData _locationData;
  @override
    void initState() {
      _addressInputFocusNode.addListener(_updateLocation);
      //getStaticMap(_addressInputController.text);
      if (widget.product!=null){
        _getStaticMap(widget.product.location.address, geocode: false);

      }

      super.initState();
    }

  void _getStaticMap(String address, {bool geocode : true, double lat, double lng}) async{

    if (address.isEmpty){
      
      setState(() {
              _staticMapUri = null;
            });

      widget.setLocation(null);

      return;
    }
    
    if(geocode){

      final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {'address': address, 'key': GOOGLE_API_KEY});

      http.Response response = await http.get(uri);

      final decodedResponse = json.decode(response.body);
      print(decodedResponse);
      final String formattedAddress = decodedResponse['results'][0]['formatted_address'];
      final coords = decodedResponse['results'][0]['geometry']['location'];

      _locationData = LocationData(address: formattedAddress, latitude: coords['lat'],longitude: coords['lng']);

    } else{
        if (lat==null || lng==null){
          _locationData = widget.product.location;
        } else{
          _locationData = new LocationData(address: address, latitude: lat, longitude: lng);          
        }
    }
  
    //final StaticMapProvider staticMapViewProvider = StaticMapProvider('AIzaSyB1Vp0HU8lmvESc5TtvXBBznW1m6zDBPuc');
    /*
    final Uri staticMapUri = staticMapViewProvider.getStaticUriWithMarkers([
      Marker('position', 'Position', _locationData.latitude, _locationData.longitude)
    ], center: Location(_locationData.latitude, _locationData.longitude), width: 500, height: 300, maptype: StaticMapViewType.roadmap);
    */

    if (mounted){ //Whether this [State] object is currently in a tree.
    
      final Map<String, String> params = {'center':'${_locationData.latitude.toString()},${_locationData.longitude.toString()}', 'zoom':'13', 'size':'500x300', 'maptype':'roadmap','key':'AIzaSyB1Vp0HU8lmvESc5TtvXBBznW1m6zDBPuc'};
      
      final Uri staticMapUri = (_locationData.latitude==null || _locationData.longitude==null) ? null : Uri.https('maps.googleapis.com', 'maps/api/staticmap', params);

      print('URI:' + staticMapUri.toString());

      widget.setLocation(_locationData);

      setState(() {
          _addressInputController.text = _locationData.address;
          _staticMapUri = staticMapUri;
        });
    }

  }

  Future<String> getAddress(double lat, double lng)async{
    
    final uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {'latlng': '${lat.toString()},${lng.toString()}', 'key': GOOGLE_API_KEY});

    final http.Response response = await http.get(uri);

    final decodedResponse = json.decode(response.body);

    final String formattedAddress = decodedResponse['results'][0]['formatted_address'];

    return formattedAddress;
  }

  void _getUserLocation() async{
    final location = geoloc.Location();
    try{
      final currentLocation = await location.getLocation();
      final address = await getAddress(currentLocation.latitude, currentLocation.longitude);
      _getStaticMap(address, geocode: false, lat: currentLocation.latitude, lng:currentLocation.longitude);
    }
    catch(error){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(title: Text('Could not fetch location'), content: Text('Please add an address manually'), actions: <Widget>[
          FlatButton(child: Text('Ok'), onPressed: (){
            Navigator.pop(context);
          },)
        ],);
      });
    }
    
    
  }

  void _updateLocation(){
    if(!_addressInputFocusNode.hasFocus){
      _getStaticMap(_addressInputController.text);
    }
  } 

  @override
    void dispose() {
      _addressInputFocusNode.removeListener(_updateLocation);
      super.dispose();
    }

  @override
    Widget build(BuildContext context) {      
      return Column(children: <Widget>[
        EnsureVisibleWhenFocused(focusNode: _addressInputFocusNode, child: TextFormField(
          focusNode: _addressInputFocusNode,
          controller: _addressInputController,
          decoration: InputDecoration(labelText: 'Address'),
          validator: (String value){
            if (_locationData==null || value.isEmpty){
              return 'No valid location found';
            }
          },
        ),),
        SizedBox(height: 10.0,),
        FlatButton(child: Text('Locate User'), onPressed: _getUserLocation,),
        SizedBox(height: 10.0,),
        _staticMapUri==null ?Container() : Image.network(_staticMapUri.toString())
      ],);
    }
}
