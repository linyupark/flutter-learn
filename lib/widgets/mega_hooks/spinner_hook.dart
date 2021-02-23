import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

RotationTransition useMegaSpinnerWidget({
  // 旋转内容（必填）
  @required StatelessWidget child,
  // 旋转一次时长, 默认1秒
  @required AnimationController repeatController,
}) {
  return use(_SpinnerIcon(
    child: child,
    repeatController: repeatController,
  ));
}

class _SpinnerIcon extends Hook<RotationTransition> {
  final StatelessWidget child;
  final AnimationController repeatController;

  _SpinnerIcon({
    this.child,
    this.repeatController,
  });

  @override
  _SpinnerIconState createState() => _SpinnerIconState();
}

class _SpinnerIconState extends HookState<RotationTransition, _SpinnerIcon> {
  @override
  void initHook() {
    hook.repeatController.repeat();
    super.initHook();
  }

  @override
  RotationTransition build(BuildContext context) {
    return RotationTransition(
      // 使用旋转
      turns: hook.repeatController,
      child: hook.child,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
