import 'package:call_saver/arrowMode.dart';
import 'package:call_saver/listDevices.dart';
import 'package:call_saver/joystickMode.dart';
import 'package:call_saver/robot.dart';
import 'package:call_saver/serial/Serial.dart';
import 'package:flutter/material.dart';
import 'package:call_saver/routes/Routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static final Robot mainRobot = Robot();
  static final Serial mainSerial = Serial(MyApp.mainRobot);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    MyApp.mainSerial.initSerial();
    return MaterialApp(
      routes: {
        Routes.listDevices: (context) => ListDevices(),
        Routes.arrowMode: (context) => ArrowMode(),
        Routes.joystickMode: (context) => JoystickMode(),
      },
    );
  }
}
