import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widgets/mega_text_tabs.dart';

final _dateRangeTabs = ['Toaday', '7 Days', '30 Days', 'Custom'];

class _CustomDateRange extends HookWidget {
  final String startAt;
  final String endAt;
  final Function onClose;

  _CustomDateRange({
    this.startAt,
    this.endAt,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final _startAt = useState(startAt);
    final _endAt = useState(endAt);

    return Scaffold(
      appBar: AppBar(
        title: Text('Custom'),
        centerTitle: true,
        leading: IconButton(
          onPressed: onClose ?? () {},
          icon: Container(
            child: Icon(
              Icons.close,
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text('DONE', style: TextStyle(color: Colors.white)),
            onPressed: () {},
          )
        ],
      ),
      body: Text('Custom'),
    );
  }
}

dynamic _tabController;

class TabPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _currentType = useState('');
    final _currentDateRange = useState('');
    final _customDateRange = useState('');
    final _customPageVisible = useState(false);

    final _onTransDateRangeChange = (text, _tab) async {
      _currentDateRange.value = text;
      if (text == 'Custom') {
        _tabController = _tab;
      }
    };

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('TabPage'),
          ),
          body: Column(children: <Widget>[
            Container(
              child: MegaTextTabs(
                onChange: (text, _tab) {
                  _currentType.value = text;
                  log('${_tab.index}');
                },
              ),
            ),
            Container(
              child: MegaTextTabs(
                tabs: _dateRangeTabs,
                onChange: _onTransDateRangeChange,
                onTap: (index) {
                  _customPageVisible.value = index == 3;
                },
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
        ),
        _customPageVisible.value
            ? _CustomDateRange(
                onClose: () {
                  _customPageVisible.value = false;
                  _tabController.index = _tabController.previousIndex;
                  _customDateRange.value = '';
                  _currentDateRange.value =
                      _dateRangeTabs[_tabController.index];
                },
              )
            : Text(''),
      ],
    );
  }
}
