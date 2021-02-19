import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useTimeAliveHook(BuildContext context) {
  use(const _TimeAlive());
}

class _TimeAlive extends Hook<void> {
  const _TimeAlive();

  @override
  _TimeAliveState createState() => _TimeAliveState();
}

class _TimeAliveState extends HookState<void, _TimeAlive> {
  DateTime startAt;

  @override
  void initHook() {
    super.initHook();
    startAt = DateTime.now();
  }

  @override
  void build(BuildContext context) {}

  @override
  void dispose() {
    print(DateTime.now().difference(startAt));
    super.dispose();
  }
}
