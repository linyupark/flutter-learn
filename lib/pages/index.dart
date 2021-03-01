import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../router.dart';

class IndexPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IndexPage'),
      ),
      body: Column(children: <Widget>[
        OutlineButton(
          onPressed: () {
            AppRouter.router.navigateTo(context, 'tab');
          },
          child: Text('Tab 切换'),
        )
      ]),
    );
  }
}
