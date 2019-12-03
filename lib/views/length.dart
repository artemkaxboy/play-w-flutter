import 'package:flutter/cupertino.dart';

import '../main.dart';

class LengthWidget extends InfoPanelText {
  LengthWidget(Length data) : super(data.toString());
}

enum LengthFormat {
  DECIMAL,
  IMPERIAL,
}

class Length {
  static const _LENGTH_NAN = {
    LengthFormat.DECIMAL: "--.-- m",
    LengthFormat.IMPERIAL: "--.- f"
  };

  double value;
  LengthFormat format;

  Length(this.value, {this.format = LengthFormat.DECIMAL});

  @override
  String toString() {
    if (value?.isNaN ?? true) return getDefault();
    return getFormatted();
  }

  String getDefault() => _LENGTH_NAN[format];

  String getFormatted() {
    switch (format) {
      case LengthFormat.IMPERIAL:
        return getFeet(value).toStringAsFixed(1) + "f";
      default:
        return value.toStringAsFixed(2) + "m";
    }
  }

  static double getFeet(double m) => m * 3.28084;
}
