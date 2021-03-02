import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widgets/mega_text_tabs.dart';

const _dateRangeTabs = ['Toaday', '7 Days', '30 Days', 'Custom'];

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
    final _startController = useTextEditingController(text: startAt ?? '');
    final _endController = useTextEditingController(text: endAt ?? '');
    final _startAtFocus = useFocusNode();
    final _endAtFocus = useFocusNode();
    final _currentFocus = useState('');

    final _initialDateTime = () {
      if (_currentFocus.value == 'Start') {
        return startAt == '' ? DateTime.now().toString() : startAt;
      }
      if (_currentFocus.value == 'End') {
        return endAt == '' ? DateTime.now().toString() : endAt;
      }
      return DateTime.now().toString();
    };

    final _datePicker = () {
      if (_currentFocus.value == '') return Text('');
      return Container(
        margin: EdgeInsets.only(top: 8.0, bottom: 40.0),
        height: MediaQuery.of(context).copyWith().size.height / 3,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: DateTime.parse(_initialDateTime()),
          onDateTimeChanged: (dateTime) {
            if (_currentFocus.value == 'Start') {
              _startController.text =
                  '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
            }
            if (_currentFocus.value == 'End') {
              _endController.text =
                  '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
            }
          },
        ),
      );
    };

    final _w = MediaQuery.of(context).size.width;

    useEffect(() {
      _startAtFocus.addListener(() async {
        _currentFocus.value = '';
        await Future.delayed(Duration(milliseconds: 100));
        if (_startAtFocus.hasFocus) {
          _currentFocus.value = 'Start';
        }
      });
      _endAtFocus.addListener(() async {
        _currentFocus.value = '';
        await Future.delayed(Duration(milliseconds: 100));
        if (_endAtFocus.hasFocus) {
          _currentFocus.value = 'End';
        }
      });
      return;
    }, []);

    final _dateInputContainer = (String text) {
      var focusNode;
      var controller;
      if (text == 'Start') {
        focusNode = _startAtFocus;
        controller = _startController;
      } else {
        focusNode = _endAtFocus;
        controller = _endController;
      }
      return Container(
        width: _w / 3,
        child: TextField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.datetime,
          focusNode: focusNode,
          controller: controller,
          decoration: InputDecoration(
            hintText: text,
            hintStyle: TextStyle(color: Color(0xffcccccc)),
          ),
        ),
      );
    };

    return Scaffold(
        appBar: AppBar(
          title: Text('Custom'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              onClose(null, null);
            },
            icon: Container(
              child: Icon(
                Icons.close,
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('DONE', style: TextStyle(color: Colors.white)),
              onPressed: () {
                onClose(_startController.text, _endController.text);
              },
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 40,
              width: _w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 开始时间
                  _dateInputContainer('Start'),
                  Text('To', style: TextStyle(height: 3)),
                  // 开始时间
                  _dateInputContainer('End'),
                ],
              ),
            ),
            _datePicker(),
          ],
        ));
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
    final _customDateRangeList = useMemoized(() {
      return _customDateRange.value == ''
          ? ['', '']
          : _customDateRange.value.split('|');
    }, [_customDateRange.value]);

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
                startAt: _customDateRangeList[0],
                endAt: _customDateRangeList[1],
                onClose: (_start, _end) {
                  _customPageVisible.value = false;
                  if (_start == null) {
                    if (_customDateRange.value != '') {
                      return;
                    }
                    _tabController.index = _tabController.previousIndex;
                    _customDateRange.value = '';
                    _currentDateRange.value =
                        _dateRangeTabs[_tabController.index];
                    return;
                  }
                  _customDateRange.value = '$_start|$_end';
                },
              )
            : Text(''),
      ],
    );
  }
}
