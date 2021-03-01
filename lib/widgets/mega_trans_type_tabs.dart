import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MegaTransTypeTabs extends HookWidget {
  // 选中回调
  final Function(String type, int index) onSelected;
  // tab 列表（可选）
  final List<String> tabs;
  // 默认选中序号
  final int defaultIndex;

  MegaTransTypeTabs({
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
    final _currentIndex = useState(defaultIndex);
    final _tabController = useTabController(initialLength: tabs.length);

    // tab 改变监听处理
    _tabController.addListener(() {
      _currentIndex.value = _tabController.index;
      // onSelected(tabs[_tabController.index], _tabController.index);
    });

    onSelected(tabs[_tabController.index], _tabController.index);

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
      indicatorColor: Color(0xffffffff),
    );
  }
}
