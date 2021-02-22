import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TestPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TestPage'),
      ),
      body: Column(children: <Widget>[]),
    );
  }
}
