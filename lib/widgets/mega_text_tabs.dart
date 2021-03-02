import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MegaTextTabs extends HookWidget {
  // 选中回调
  final Function onSelected;
  // tab 列表（可选）
  final List<String> tabs;
  // 默认选中序号
  final int defaultIndex;

  MegaTextTabs({
    @required this.onSelected,
    this.tabs = const [
      'All',
      'Cash In',
      'Send Money',
      'Buy Load',
      'Pay Bills',
      'Cash Pick Up',
      'KYC',
      'ePIN'
    ],
    this.defaultIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final _tabController = useTabController(
      initialLength: tabs.length,
      initialIndex: defaultIndex,
    );

    final setIndex = (int index) {
      _tabController.index = index;
      onSelected({
        'text': tabs[index],
        'index': index,
      });
    };

    final previousIndex = () {
      _tabController.index = _tabController.previousIndex;
      onSelected({
        'text': tabs[_tabController.index],
        'index': _tabController.index,
      });
    };

    final _tabOnChangeListener = () {
      // 避免二次执行，在改变中就执行
      if (_tabController.indexIsChanging) {
        onSelected({
          'text': tabs[_tabController.index],
          'index': _tabController.index,
          'previousIndex': previousIndex,
          'setIndex': setIndex,
        });
      }
    };

    useEffect(() {
      // tab 改变监听处理
      _tabController.addListener(_tabOnChangeListener);

      // 这里没有延迟会有并发渲染报错（why）
      Timer(Duration(milliseconds: 1), () {
        onSelected({
          'text': tabs[_tabController.index],
          'index': _tabController.index,
          'previousIndex': previousIndex,
          'setIndex': setIndex,
        });
      });
      return () {};
    }, []);

    return TabBar(
      isScrollable: true,
      controller: _tabController,
      tabs: [
        for (final tab in tabs) Tab(text: tab),
      ],
      labelColor: Color(0xFF00A0E9),
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelColor: Colors.grey,
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      indicatorColor: Colors.transparent,
    );
  }
}
