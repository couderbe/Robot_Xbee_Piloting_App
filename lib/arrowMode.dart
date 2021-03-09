import 'package:flutter/material.dart';
import 'package:call_saver/basicComponents.dart';
import 'package:call_saver/serial/Serial.dart';
import 'package:call_saver/main.dart';
import 'package:call_saver/robot.dart';

class ArrowMode extends StatelessWidget {
  static const String routeName = '/arrowMode';
  static const double size = 100.0;
  static const double OFFSET = 100.0;
  final Serial serial = MyApp.mainSerial;
  final Robot robot = MyApp.mainRobot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(),
      drawer: BasicDrawer(),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: <Widget>[
          Container(),
          Center(
            child: IconButton(
              icon: Icon(Icons.arrow_drop_up),
              color: Colors.red,
              iconSize: size,
              onPressed: () {
                double _x = robot.x + OFFSET;
                double _y = robot.y;
                String _command = "m $_x $_y";
                serial.sendString(_command);
              },
            ),
          ),
          Container(),
          Center(
            child: IconButton(
              icon: Icon(Icons.arrow_left),
              color: Colors.red,
              iconSize: size,
              onPressed: () {
                double _x = robot.x;
                double _y = robot.y - OFFSET;
                String _command = "m $_x $_y";
                serial.sendString(_command);
              },
            ),
          ),
          Center(
            child: IconButton(
                icon: Icon(Icons.circle),
                color: Colors.red,
                iconSize: size,
                onPressed: () {
                  serial.sendString("s");
                  serial.serialData.add(Text("Coucou c'est le bouton rouge"));
                }),
          ),
          Center(
            child: IconButton(
                icon: Icon(Icons.arrow_right),
                color: Colors.red,
                iconSize: size,
                onPressed: () {
                  double _x = robot.x;
                  double _y = robot.y + OFFSET;
                  String _command = "m $_x $_y";
                  serial.sendString(_command);
                }),
          ),
          Container(),
          Center(
            child: IconButton(
                icon: Icon(Icons.arrow_drop_down),
                color: Colors.red,
                iconSize: size,
                onPressed: () {
                  double _x = robot.x - OFFSET;
                  double _y = robot.y;
                  String _command = "m $_x $_y";
                  serial.sendString(_command);
                }),
          ),
        ],
      ),
    );
  }
}
