import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:call_saver/basicComponents.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:call_saver/serial/Serial.dart';

class ListDevices extends StatefulWidget {
  static const String routeName = '/';
  final Serial serial;
  ListDevices(this.serial);
  @override
  _ListDevicesState createState() => _ListDevicesState();
}

class _ListDevicesState extends State<ListDevices> {
  TextEditingController _textController = TextEditingController();
  List<Widget> _serialData = [];

  void serialDataListener() {
    setState(() {
      _serialData = widget.serial.serialData;
      print("serialDataListener");
      print(_serialData);
    });
  }

  @override
  void initState() {
    super.initState();
    print("InitState");
    print(widget.serial.serialData.toString());
    _serialData = widget.serial.serialData;
    widget.serial.serialData.add(Text("initState"));
    widget.serial.addListener(serialDataListener);

    if (widget.serial.ports.isNotEmpty) {
      widget.serial.serialData
          .add(Text(widget.serial.ports.elementAt(0).toString()));
    }
    UsbSerial.usbEventStream.listen((UsbEvent event) {
      widget.serial.serialData.add(Text("$event"));
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.serial.removeListener(serialDataListener);
    print("Dispose listDevice");
  }

  @override
  Widget build(BuildContext context) {
    String _status = widget.serial.status;
    return Scaffold(
      appBar: BasicAppBar(),
      drawer: BasicDrawer(),
      body: Center(
          child: Column(children: <Widget>[
        Text(
            widget.serial.ports.length > 0
                ? "Available Serial Ports"
                : "No serial devices available",
            style: Theme.of(context).textTheme.headline6),
        ...widget.serial.ports,
        Text('Status: $_status\n'),
        ListTile(
          title: TextField(
            controller: _textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Text To Send',
            ),
          ),
          trailing: RaisedButton(
            child: Text("Send"),
            onPressed: widget.serial.port == null
                ? null
                : () async {
                    if (widget.serial.port == null) {
                      return;
                    }
                    String data = _textController.text + "\r\n";
                    await widget.serial.port
                        .write(Uint8List.fromList(data.codeUnits));
                    _textController.text = "";
                  },
          ),
        ),
        Text("Result Data", style: Theme.of(context).textTheme.headline6),
        ..._serialData,
      ])),
    );
  }
}
