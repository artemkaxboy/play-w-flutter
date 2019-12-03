import 'package:flutter_test/flutter_test.dart';
import 'package:satfinder_flutter/views/coord.dart';

main() {
  final min = 1 / 60;
  final sec = min / 60;
  test('Float/Deg converter testing', () {
    expect(Coord.getDegrees(1.0), 1, reason: "Wrong degrees converting result");
    expect(Coord.getDegrees(-51), -51,
        reason: "Wrong degrees converting result");
    expect(Coord.getDegrees(10.9999999), 10,
        reason: "Wrong degrees converting result");
    expect(Coord.getDegrees(-10.9999999), -10,
        reason: "Wrong degrees converting result");
    expect(Coord.getDegrees(300.00000001), 300,
        reason: "Wrong degrees converting result");
    expect(Coord.getDegrees(-321.00000001), -321,
        reason: "Wrong degrees converting result");
  });

  test('Float/Min converter testing', () {
    expect(Coord.getMinutes(1.0), 0, reason: "Wrong degrees converting result");
    expect(Coord.getMinutes(-51.25), 15,
        reason: "Wrong degrees converting result");
    expect(Coord.getMinutes(10 + min - 0.00000000001), 0,
        reason: "Wrong degrees converting result");
    expect(Coord.getMinutes(60 + min), 1,
        reason: "Wrong degrees converting result");
    expect(Coord.getMinutes(321 - min - 1e-13), 58,
        reason: "Wrong degrees converting result");
    expect(Coord.getMinutes(-321 + min), 59,
        reason: "Wrong degrees converting result");
    expect(Coord.getMinutes(-777.9999999999), 59,
        reason: "Wrong degrees converting result");
  });

  test('Float/Sec converter testing', () {
    expect(Coord.getSeconds(1.0), 0, reason: "Wrong degrees converting result");
    expect(Coord.getSeconds(-51.25 - 45 * sec), 45,
        reason: "Wrong degrees converting result");
    expect(Coord.getSeconds(-51.25 + 45 * sec), 15,
        reason: "Wrong degrees converting result");
    expect(Coord.getSeconds(10 + sec - 0.00000000001), 0,
        reason: "Wrong degrees converting result");
    expect(Coord.getSeconds(60 + sec), 1,
        reason: "Wrong degrees converting result");
    expect(Coord.getSeconds(321 - sec - 1e-13), 58,
        reason: "Wrong degrees converting result");
    expect(Coord.getSeconds(-321 + sec), 59,
        reason: "Wrong degrees converting result");
    expect(Coord.getSeconds(-777.9999999999), 59,
        reason: "Wrong degrees converting result");
  });

  test('Coord string testing', () {
    final coord1 = Coord(double.nan);
    expect(coord1.toString(), "--.-----°", reason: "Default string error");

    final coord2 = Coord(double.nan, format: CoordFormat.MIN_SEC);
    expect(coord2.toString(), "--°--'--\"", reason: "Default string error");

    final coord3 = Coord(double.nan, format: CoordFormat.FLOAT);
    expect(coord3.toString(), coord1.toString(),
        reason: "Default string error");

    final coord4 = Coord(1);
    expect(coord4.toString(), "1.00000°", reason: "Formatting error");

    coord4.value = 1.123456;
    expect(coord4.toString(), "1.12346°", reason: "Formatting error");

    coord4.value = -1.123456;
    expect(coord4.toString(), "-1.12346°", reason: "Formatting error");

    coord4.value = -10.999999;
    expect(coord4.toString(), "-11.00000°", reason: "Formatting error");

    final coord5 = Coord(1, format: CoordFormat.MIN_SEC);
    expect(coord5.toString(), "1°00'00\"", reason: "Formatting error");

    coord5.value = 120 + 5 * min + 6 * sec;
    expect(coord5.toString(), "120°05'06\"", reason: "Formatting error");

    coord5.value = 120 - 5 * min - 6 * sec;
    expect(coord5.toString(), "119°54'54\"", reason: "Formatting error");

    coord5.value = -120 + 5 * min + 6 * sec;
    expect(coord5.toString(), "-119°54'54\"", reason: "Formatting error");

    coord5.value = -120 - 5 * min - 6 * sec;
    expect(coord5.toString(), "-120°05'06\"", reason: "Formatting error");
  });
}
