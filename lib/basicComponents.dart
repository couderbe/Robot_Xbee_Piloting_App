import 'package:flutter/material.dart';
import 'package:call_saver/routes/Routes.dart';

class BasicAppBar extends StatefulWidget implements PreferredSizeWidget {
  BasicAppBar({Key key})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _BasicAppBarState createState() => _BasicAppBarState();
}

class _BasicAppBarState extends State<BasicAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('USB Serial Communication'),
    );
  }
}

class BasicDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              "Choose your mode",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.change_history),
            title: Text("Connexion"),
            onTap: () {
              print("Connexion");
              Navigator.pushReplacementNamed(context, Routes.listDevices);
            },
          ),
          ListTile(
            title: Text("Arrow Mode"),
            onTap: () {
              print("Arrow Mode");
              Navigator.pushReplacementNamed(context, Routes.arrowMode);
            },
          ),
          ListTile(
              title: Text("Joystick Mode"),
              onTap: () {
                print("JoystickMode");
                Navigator.pushReplacementNamed(context, Routes.joystickMode);
              }),
          ListTile(
              title: Text("Map Mode"),
              onTap: () {
                print("MapMode");
              }),
        ],
      ),
    );
  }
}

class StatefulText extends StatefulWidget {
  final ChangeNotifier observedObject;
  StatefulText(this.observedObject);

  @override
  _StatefulTextState createState() => _StatefulTextState();
}

class _StatefulTextState extends State<StatefulText> {
  String _textHolder = "";

  void textChangeListener() {
    setState(() {
      _textHolder = "";
    });
  }

  @override
  void initState() {
    super.initState();
    widget.observedObject.addListener(textChangeListener);
  }

  @override
  Widget build(BuildContext context) {
    return Text("$_textHolder");
  }
}
