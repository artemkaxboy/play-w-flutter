// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:satfinder_flutter/views/coord.dart';
import 'package:satfinder_flutter/views/length.dart';

import 'src/service/LocationService.dart';


const Color panelBackground = Color.fromARGB(0x60, 0x3f, 0x51, 0xb5);

void main() {
  runApp(
    // Provide the model to all widgets within the app. We're using
    // ChangeNotifierProvider because that's a simple way to rebuild
    // widgets when a model changes. We could also just use
    // Provider, but then we would have to listen to Counter ourselves.
    //
    // Read Provider's docs to learn about all the available providers.
    ChangeNotifierProvider(
      // Initialize the model in the builder. That way, Provider
      // can own Counter's lifecycle, making sure to call `dispose`
      // when not needed anymore.
      create: (context) => LocationStorage(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: MainScreen(),
    );
  }
}

class LocationStorage with ChangeNotifier {
  var latitude;
  var longitude;
  var accuracy;
  final random = new Random();

  void update(CameraPosition position) {
    latitude = position.target.latitude;
    longitude = position.target.longitude;
    accuracy = random.nextDouble();
    notifyListeners();
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: MapSample(),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              children: <Widget>[
                AppBar(
                  title: Text('Maps Example'),
                  elevation: 0.0,
                  backgroundColor: panelBackground,
                ),
                Consumer<LocationStorage>(
                  builder: (context, location, child) => PanelSample(
                    location: location,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TestLoc extends StatelessWidget {
  const TestLoc({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    return Center(
      child: Text(
          '${userLocation?.latitude}\n${userLocation?.longitude}'),
    );
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
  final LocationStorage location;

  const PanelSample({Key key, this.location}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanelSampleState();
  }
}

class PanelSampleState extends State<PanelSample> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: panelBackground,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: <Widget>[
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        CoordWidget(Coord(widget.location.latitude)),
                        CoordWidget(Coord(widget.location.longitude)),
                        LengthWidget(Length(widget.location.accuracy)),
                        InfoPanelText("GPS: "),
                        InfoPanelText("GPS: "),
                      ],
                    ),
                  ],
                )),
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
                        InfoPanelText("Azimuth: "),
                        InfoPanelText("Azimuth: "),
                        InfoPanelText("Azimuth: "),
                        InfoPanelText("Azimuth: "),
                        InfoPanelText("Azimuth: "),
                      ],
                    ),
                  ]),
            ),
            StreamProvider<UserLocation>(
              create: (context) => LocationService().locationStream,
              child: TestLoc(),
            ),
          ],
        ));
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
        onCameraMove: (position) {
          Provider.of<LocationStorage>(context, listen: false).update(position);
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
