import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../utils/resize.dart';

// 列表项主标题
class MegaListItemTitle extends HookWidget {
  @required
  final String title;
  final Color color;
  final double size;

  MegaListItemTitle({
    this.title,
    this.color = const Color(0xFF232323),
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final resize = Resize(context);
    final titleSize = size ?? resize.px(14);

    return Text(title,
        style: TextStyle(
          fontSize: titleSize,
          color: color,
          fontWeight: FontWeight.bold,
          height: 1,
        ));
  }
}
