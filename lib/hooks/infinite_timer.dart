import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

int useInfiniteTimer({int startNumber = 0}) {
  return use(_InfiniteTimer(startNumber: startNumber));
}

class _InfiniteTimer extends Hook<int> {
  const _InfiniteTimer({@required this.startNumber});

  final int startNumber;

  @override
  _InfiniteTimerState createState() => _InfiniteTimerState();
}

class _InfiniteTimerState extends HookState<int, _InfiniteTimer> {
  Timer _timer;
  int _number = 0;

  @override
  void initHook() {
    super.initHook();
    _number = hook.startNumber;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _number = timer.tick + hook.startNumber;
      });
    });
  }

  @override
  int build(BuildContext context) {
    return _number;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
