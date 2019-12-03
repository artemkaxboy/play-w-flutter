import 'package:flutter/cupertino.dart';

import '../main.dart';

class CoordWidget extends InfoPanelText {
  CoordWidget(Coord data) : super(data.toString());
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

  Coord(this.value, {this.format = CoordFormat.FLOAT});

  @override
  String toString() {
    if (value?.isNaN ?? true) return getDefault();
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

  static int getSeconds(double deg) => (deg * 3600).abs().floor() % 60;
}
