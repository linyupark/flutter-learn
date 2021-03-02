import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MegaTextTabs extends HookWidget {
  // 变化回调
  final Function(String text, TabController controller) onChange;
  // 不管有无变化点击回调
  final Function(int index) onTap;
  // tab 列表
  final List<String> tabs;
  // 默认选中序号
  final int defaultIndex;

  MegaTextTabs({
    @required this.onChange,
    this.onTap,
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

    final _tabOnChangeListener = () {
      // 避免二次执行，在改变中就执行
      if (_tabController.indexIsChanging) {
        onChange(tabs[_tabController.index], _tabController);
      }
    };

    useEffect(() {
      // tab 改变监听处理
      _tabController.addListener(_tabOnChangeListener);

      // 这里没有延迟会有并发渲染报错（why）
      Timer(Duration(milliseconds: 1), () {
        onChange(tabs[_tabController.index], _tabController);
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
      onTap: onTap ?? (_) {},
    );
  }
}
