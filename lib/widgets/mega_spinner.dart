import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MegaSpinner extends HookWidget {
  final StatelessWidget child;
  final int duration;

  MegaSpinner({
    @required this.child,
    this.duration = 1000,
  });

  @override
  Widget build(BuildContext context) {
    final spinnerController = useAnimationController(
      duration: Duration(milliseconds: duration),
    );
    spinnerController.repeat();

    return RotationTransition(
      // 使用旋转
      turns: spinnerController,
      child: child,
    );
  }
}
