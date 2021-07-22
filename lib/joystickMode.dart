import 'dart:math';

import 'package:call_saver/robot.dart';
import 'package:call_saver/serial/Serial.dart';
import 'package:flutter/material.dart';
import 'package:call_saver/basicComponents.dart';
import 'package:control_pad/control_pad.dart';
import 'package:call_saver/main.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class JoystickMode extends StatelessWidget {
  // Il semblerai qu'en utilisant la propriété interval de JoystickView ça remplace l'utilisation des timestamps
  static int lastMessageSendTime = DateTime.now().millisecondsSinceEpoch;
  static const int timeBetweenMessages = 100;
  static const String routeName = '/joystickMode';

  final Serial serial = MyApp.mainSerial;
  final Robot robot = MyApp.mainRobot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(),
      drawer: BasicDrawer(),
      body: Column(
        children: [
          PropertyChangeProvider(
            value: robot,
            child: Row(
              children: [
                Expanded(child: ChangingText(['x'])),
                Expanded(child: ChangingText(['y'])),
                Expanded(child: ChangingText(['angle'])),
              ],
            ),
          ),
          JoystickView(
            backgroundColor: Colors.blue,
            innerCircleColor: Colors.blueAccent,
            onDirectionChanged: (degrees, distance) {
              if (DateTime.now().millisecondsSinceEpoch - lastMessageSendTime >
                  timeBetweenMessages) {
                serial.sendString("o");
                double _consOmega;
                double _consSpeed = pow(distance, 5) * 1000;
                double _errAngle = robot.angle - degrees;
                /*if (degrees <= 180) {
                  _consOmega = -degrees / 2;
                } else {
                  _consOmega = -(degrees - 360) / 2;
                }
                _consOmega = pow(_consOmega / 90, 5) * 100;*/
                if (_errAngle.abs() <= 180) {
                  if (_errAngle >= 0) {
                    _consOmega = -_errAngle /
                        2; // Là on considère que la vitesse voulue est celle qui nous met dans la bonne position en 2 sec
                  } else {
                    _consOmega = _errAngle / 2;
                  }
                } else {
                  if (_errAngle >= 0) {
                    _errAngle -= 360;
                    _consOmega = -_errAngle / 2;
                  } else {
                    _errAngle += 360;
                    _consOmega = _errAngle / 2;
                  }
                }
                _consOmega = pow(_consOmega / 90, 5) * 100;
                //print("Deg: $degrees Dist: $distance");
                print("Speed: $_consSpeed Omega: $_consOmega");
                serial.sendString("j $_consSpeed $_consOmega");
                lastMessageSendTime = DateTime.now().millisecondsSinceEpoch;
              }
            },
          ),
          RaisedButton(onPressed: () {
            serial.sendString("s");
          }),
        ],
      ),
    );
  }
}
