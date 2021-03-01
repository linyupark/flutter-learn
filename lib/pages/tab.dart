import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widgets/mega_trans_type_tabs.dart';

class TabPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _currentType = useState('');
    return Scaffold(
      appBar: AppBar(
        title: Text('TabPage'),
      ),
      body: Column(children: <Widget>[
        Container(child: MegaTransTypeTabs(
          onSelected: (type, _) {
            _currentType.value = type;
          },
        )),
        Container(
          child: Text(_currentType.value),
        ),
      ]),
    );
  }
}
