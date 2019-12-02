import 'package:flutter/cupertino.dart';

//class CoordWidget extends StatefulWidget {
//  @override
//  State<CoordWidget> createState() => CoordWidgetState();
//}
//
//class CoordWidgetState extends State<CoordWidget> {
//  var _coord = new Coord();
//
//  @override
//  Widget build(BuildContext context) {
//    return new InfoPanelValue(_coord.toString());
//  }
//}

class CoordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}

enum CoordFormat {
  FLOAT,
  MIN_SEC,
}

class Coord {
  static const _COORD_NAN = {
    CoordFormat.FLOAT: "--.-----°",
    CoordFormat.MIN_SEC: "--°--'--\""
  };

  static const _COORD_FORMAT = {
    CoordFormat.FLOAT: "%.5f°",
    CoordFormat.MIN_SEC: "%d°%d'%d\""
  };

  double value;
  CoordFormat format;

  Coord({this.value = double.nan, this.format = CoordFormat.FLOAT});

  @override
  String toString() {
    if (value.isNaN) return getDefault();
    return getFormatted();
  }

  String getDefault() => _COORD_NAN[format];

  String getFormatted() {
    switch (format) {
      case CoordFormat.MIN_SEC:
        return getDegrees(value).toString() +
            "°" +
            getMinutes(value).toString().padLeft(2, "0") +
            "'" +
            getSeconds(value).toString().padLeft(2, "0") +
            '"';
      default:
        return value.toStringAsFixed(5) + "°";
    }
  }

  static int getDegrees(double deg) => deg.toInt();

  static int getMinutes(double deg) => (deg * 60).abs().floor() % 60;

  static getSeconds(double deg) => (deg * 3600).abs().floor() % 60;
}
