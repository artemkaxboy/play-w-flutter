// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const Color panelBackground = Color.fromARGB(0x60, 0x3f, 0x51, 0xb5);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(body: Center(child: MapSample())),
      Scaffold(
        appBar: AppBar(
          title: Text('Maps Exampe'),
          elevation: 0.0,
          backgroundColor: panelBackground,
        ),
        backgroundColor: Colors.transparent,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        body: PanelSample(),
      ),
    ]);
  }
}

class InfoPanelText extends Text {
  InfoPanelText(text) : super(text, style: TextStyle(color: Colors.white));
}

class InfoPanelValue extends Align {
  InfoPanelValue(text)
      : super(
          alignment: Alignment.centerRight,
          child: InfoPanelText(text),
        );
}

class PanelSample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PanelSampleState();
}

class PanelSampleState extends State<PanelSample> {
  var _latitude = 0.0;
  var _longitude = 0.0;
  var _accuracy = 0.0;
  var _distance = 0.0;
  var _azimuth = 0.0;
  var _magnetic = 0.0;
  var _current = 0.0;
  var _elevation = 0.0;
  var _polarization = 0.0;
  var _gps = 0;

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: panelBackground,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(children: <Widget>[
          Flexible(
            flex: 1,
            child: Row(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    InfoPanelText("Latitude: "),
                    InfoPanelText("Longitude: "),
                    InfoPanelText("Accuracy: "),
                    InfoPanelText("Distance: "),
                    InfoPanelText("GPS: "),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InfoPanelValue(_latitude.toString()),
                    InfoPanelText(_longitude.toString()),
                    InfoPanelText(_accuracy.toString()),
                    InfoPanelText(_distance.toString()),
                    InfoPanelText(_gps.toString()),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    InfoPanelText("Azimuth: "),
                    InfoPanelText("Magnetic: "),
                    InfoPanelText("Current: "),
                    InfoPanelText("Elevation: "),
                    InfoPanelText("Polarization: "),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InfoPanelText(_azimuth.toString()),
                    InfoPanelText(_magnetic.toString()),
                    InfoPanelText(_current.toString()),
                    InfoPanelText(_elevation.toString()),
                    InfoPanelText(_polarization.toString()),
                  ],
                ),
              ]),
          )
        ]));
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
