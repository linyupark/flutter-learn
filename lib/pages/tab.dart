import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widgets/mega_trans_type_tabs.dart';

class TabPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _currentType = useState('');
    final _currentDateRange = useState('');
    final _customDateRange = useState('');

    final _onTransDateRangeSelected = (range, _) async {
      _currentDateRange.value = range;
      if (range == 'Custom') {
        print('load');
        Locale myLocale = Localizations.localeOf(context);
        var picker = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2016),
          lastDate: DateTime(2022),
          locale: myLocale,
        );
        _customDateRange.value = picker.toString();
      }
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('TabPage'),
      ),
      body: Column(children: <Widget>[
        Container(
          child: MegaTextTabs(
            onSelected: (type, _) {
              // print('type $type');
              _currentType.value = type;
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
              _customDateRange.value != ''
                  ? Text(_customDateRange.value)
                  : Text(''),
            ],
          ),
        ),
      ]),
    );
  }
}
