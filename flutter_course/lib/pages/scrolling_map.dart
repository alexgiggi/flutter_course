// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScrollingMapPage extends StatelessWidget{
  final double lat, long;
  ScrollingMapPage(this.lat, this.long);
  
  @override
  Widget build(BuildContext context) {
    return ScrollingMapBody(lat, long);
  }
}

class ScrollingMapBody extends StatelessWidget {
  
  final double lat, long;
  ScrollingMapBody(this.lat, this.long);

  @override
  Widget build(BuildContext context) {
    LatLng _center = LatLng(lat, long);
    print('*** ScrollingMapBody - latitudine: ${_center.latitude}, longitudine: ${_center.longitude}');

    return ListView(
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Text('This map consumes all touch events.'),
                ),
                Center(
                  child: SizedBox(
                    width: 400.0,
                    height: 600.0,
                     child: GoogleMap(onMapCreated: onMapCreated, initialCameraPosition: CameraPosition(target: _center, zoom: 15.0,),
                     gestureRecognizers:<Factory<OneSequenceGestureRecognizer>>[Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())].toSet()
                     ),
                    //child: Container()
                  ),
                ),
              ],
            ),
          ),
        ),        
      ],
    );
  }

  void onMapCreated(GoogleMapController controller) {
    controller.addMarker(MarkerOptions(
      position: LatLng(
        lat,
        long,
      ),
      infoWindowText: const InfoWindowText('An interesting location', '*'),
    ));
  }
}
