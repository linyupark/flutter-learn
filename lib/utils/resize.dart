import 'package:flutter/material.dart';

class Resize {
  MediaQueryData _mediaQueryData;
  double _width;
  double _height;
  double _devicePixelRatio;
  double _ratio;

  Resize(context) {
    _mediaQueryData = MediaQuery.of(context);
    _width = _mediaQueryData.size.width;
    _height = _mediaQueryData.size.height;
    _devicePixelRatio = _mediaQueryData.devicePixelRatio;
    _ratio = _width / 375.0;
  }

  double px(double n) {
    return n * _ratio;
  }

  double onepx() {
    return 1 / _devicePixelRatio;
  }

  double screenW() {
    return _width;
  }

  double screenH() {
    return _height;
  }

  double deviceRatio() {
    return _devicePixelRatio;
  }

  double ratio() {
    return _ratio;
  }
}
