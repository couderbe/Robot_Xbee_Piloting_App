import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:usb_serial/usb_serial.dart';
import 'package:usb_serial/transaction.dart';
import 'package:call_saver/robot.dart';

class Serial extends ChangeNotifier {
  UsbPort port;
  String status = "Idle";
  List<Widget> ports = [];
  List<Widget> serialData = [];
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int deviceId;
  Timer posUpdateTimer;
  static const posUpdateDuration = const Duration(milliseconds: 90);

  Robot robot;

  Serial(robot);

  void initSerial() {
    print("Start listening for open ports");
    UsbSerial.usbEventStream.listen((UsbEvent event) {
      serialData.add(Text("$event"));
      _getPorts();
    });
    _getPorts();
    notifyListeners();
  }

  Future<bool> connectTo(device) async {
    serialData.add(Text("connectTo"));
    serialData.clear();

    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction.dispose();
      _transaction = null;
    }

    if (port != null) {
      port.close();
      port = null;
    }

    if (device == null) {
      deviceId = null;
      // Arret du timer si on se déconnecte
      if (posUpdateTimer.isActive) {
        posUpdateTimer.cancel();
      }
      status = "Disconnected";
      return true;
    }

    port = await device.create();
    if (!await port.open()) {
      status = "Failed to open port";
      return false;
    }

    deviceId = device.deviceId;
    await port.setDTR(true);
    await port.setRTS(true);
    await port.setPortParameters(
        57600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);
    /*await port.setPortParameters(
        1200, UsbPort.DATABITS_7, UsbPort.STOPBITS_1, UsbPort.PARITY_EVEN);*/

    _transaction = Transaction.stringTerminated(
        port.inputStream, Uint8List.fromList([13, 10]));

    _subscription = _transaction.stream.listen((String line) {
      robot.parseData(line);
      serialData.add(Text(line));
      if (serialData.length > 10) {
        serialData.removeAt(0);
      }
    });

    status = "Connected";
    /* Une fois qu'on est connecté on lance de façon récurrente la demande de 
    position au robot. Cette position sera ensuite traitée par le parseur*/
    posUpdateTimer =
        Timer.periodic(posUpdateDuration, (Timer t) => sendString("o"));

    notifyListeners();
    return true;
  }

  void _getPorts() async {
    serialData.add(Text("getPorts"));
    ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    print("Devices: $devices");

    devices.forEach((device) {
      ports.add(ListTile(
          leading: Icon(Icons.usb),
          title: Text(device.productName),
          subtitle: Text(device.manufacturerName),
          trailing: RaisedButton(
            child: Text(deviceId == device.deviceId ? "Disconnect" : "Connect"),
            onPressed: () {
              connectTo(deviceId == device.deviceId ? null : device)
                  .then((res) {
                _getPorts();
              });
            },
          )));
    });

    print("Ports: $ports");
    notifyListeners();
  }

  void sendString(String str) async {
    if (port == null) {
      return;
    }
    String data = str + "\r\n";
    await port.write(Uint8List.fromList(data.codeUnits));
  }
}
