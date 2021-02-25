import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../utils/resize.dart';

// Border
class MegaListItemBorder extends HookWidget {
  final Color color;
  final EdgeInsets margin;

  MegaListItemBorder({
    this.color = const Color(0xFFC3C3C3),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final resize = Resize(context);
    final borderMargin = margin ??
        EdgeInsets.only(
          left: resize.px(25),
          right: resize.px(25),
        );

    return Container(
      color: color,
      margin: borderMargin,
      constraints: BoxConstraints.expand(height: resize.onepx()),
    );
  }
}
