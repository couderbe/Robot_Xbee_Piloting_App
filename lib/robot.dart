import 'package:property_change_notifier/property_change_notifier.dart';

class Robot extends PropertyChangeNotifier<String> {
  double _x = 0;
  double _y = 0;
  double _angle = 0;

  double get x => _x;
  double get y => _y;
  double get angle => _angle;

  void setX(double x) {
    _x = x;
    notifyListeners('x');
  }

  void setY(double y) {
    _y = y;
    notifyListeners('y');
  }

  void setAngle(double angle) {
    _angle = angle;
    notifyListeners('angle');
  }

  void parseData(String str) {
    print("Data received from serial: $str");
    if (str.startsWith("pos:")) {
      // Il faut changer le code dans le strames sur teensy
      List<String> params = str.split("\t");
      setX(double.parse(params.elementAt(1)));
      setY(double.parse(params.elementAt(2)));
      setAngle(double.parse(params.elementAt(3)));
    }
  }
}
