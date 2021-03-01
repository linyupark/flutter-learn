import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import './mega_toast.dart';
import '../utils/resize.dart';

double _screenHeignt(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Timer _debounceTimer;
dynamic _toastDisposer;

int getIndexByGlobalPosition(
  BuildContext context,
  List<String> words,
  Offset globalPosition,
) {
  RenderBox box = context.findRenderObject();
  double y = box.globalToLocal(globalPosition).dy;
  //每一个Item的高度
  double itemHeight = _screenHeignt(context) / 2 / words.length;
  //clamp 防止越界
  int index = (y ~/ itemHeight).clamp(0, words.length - 1);
  // print('index = $index,${words[index]}');
  return index;
}

class MegaStrIndexBar extends HookWidget {
  // 选中回调
  final Function(String selectedStr) onSelected;

  // 默认颜色
  final Color color;

  // 选中颜色
  final Color selectedColor;

  // 默认激活序列
  final int initIndex;

  // 可选字符串索引列表
  final List<String> strList;

  MegaStrIndexBar({
    @required this.onSelected,
    this.color = const Color(0xFF999999),
    this.selectedColor = const Color(0xFF00A0E9),
    this.initIndex = -1,
    this.strList = const [
      '#',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    ],
  });

  @override
  Widget build(BuildContext context) {
    final resize = Resize(context);
    final selectedIndex = useState(initIndex);
    List<Widget> styledStrList = [];

    for (int i = 0; i < strList.length; i++) {
      Color currentColor = selectedIndex.value == i ? selectedColor : color;
      styledStrList.add(
        Expanded(
          child: Text(
            strList[i],
            style: TextStyle(
              color: currentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    final _removeToast = () {
      if (_toastDisposer != null) {
        _toastDisposer();
        _toastDisposer = null;
        print('clear $_toastDisposer');
      }
    };

    useValueChanged(selectedIndex.value, (_, __) {
      _removeToast();
      if (_debounceTimer != null) {
        _debounceTimer.cancel();
      }
      // callback debouncer
      _debounceTimer = Timer(Duration(milliseconds: 400), () {
        final String keyword = strList[selectedIndex.value];
        onSelected(keyword);
        // toast
        _toastDisposer = MegaToast.custom(
          context,
          Container(
            width: resize.px(70),
            height: resize.px(70),
            decoration: BoxDecoration(
              color: Color(0xFF000000).withOpacity(0.5),
              borderRadius: BorderRadius.circular(
                resize.px(6),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  keyword,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: resize.px(35),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          duration: 0,
        );

        Timer(Duration(milliseconds: 1000), _removeToast);
      });
    });

    useEffect(() {
      return () {
        if (_debounceTimer != null) {
          _debounceTimer.cancel();
        }
      };
    }, []);

    return Positioned(
      right: 0,
      top: _screenHeignt(context) / 8,
      width: 30,
      height: _screenHeignt(context) / 2,
      child: GestureDetector(
        child: Container(
          child: Column(
            children: styledStrList,
          ),
        ),
        // 按下
        onVerticalDragDown: (DragDownDetails details) {
          selectedIndex.value = getIndexByGlobalPosition(
            context,
            strList,
            details.globalPosition,
          );
        },
        // 滑动
        onVerticalDragUpdate: (DragUpdateDetails details) {
          selectedIndex.value = getIndexByGlobalPosition(
            context,
            strList,
            details.globalPosition,
          );
        },
      ),
    );
  }
}
