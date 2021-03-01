import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:async';

void useDebounce(int ms, Function callback) {
  return use(_Debounce(
    ms = 1000,
    callback = () {},
  ));
}

class _Debounce extends Hook<dynamic> {
  final int ms;
  final Function callback;

  _Debounce(
    this.ms,
    this.callback,
  );

  @override
  _DebounceState createState() => _DebounceState();
}

class _DebounceState extends HookState<dynamic, _Debounce> {
  Timer _timer;

  @override
  void initHook() {
    _timer = Timer(Duration(milliseconds: hook.ms), hook.callback);
    super.initHook();
  }

  @override
  build(BuildContext context) {}

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
