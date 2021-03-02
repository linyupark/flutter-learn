import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widgets/mega_text_tabs.dart';

class TabPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _currentType = useState('');
    final _currentDateRange = useState('');
    final _customDateRange = useState('');

    final _onTransDateRangeSelected = (data) async {
      _currentDateRange.value = data['text'];
      if (data['text'] == 'Custom') {
        Locale myLocale = Localizations.localeOf(context);
        var picker = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020, 6),
          lastDate: DateTime(2022, 3),
          locale: myLocale,
        );
        if (picker.toString() != 'null') {
          _customDateRange.value = picker.toString();
        } else {
          data['previousIndex']();
        }
      }
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('TabPage'),
      ),
      body: Column(children: <Widget>[
        Container(
          child: MegaTextTabs(
            onSelected: (data) {
              _currentType.value = data['text'];
            },
          ),
        ),
        Container(
          child: MegaTextTabs(
            tabs: ['Toaday', '7 Days', '30 Days', 'Custom'],
            onSelected: _onTransDateRangeSelected,
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_currentType.value),
              Text(' | '),
              Text(_currentDateRange.value),
            ],
          ),
        ),
        Container(
          child: _customDateRange.value != ''
              ? Text(_customDateRange.value)
              : Text(''),
        )
      ]),
    );
  }
}
