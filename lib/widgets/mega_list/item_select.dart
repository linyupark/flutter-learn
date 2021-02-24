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

// Header
class MegaSelectListHeader extends HookWidget {
  // 标题
  @required
  final String title;

  MegaSelectListHeader({this.title});

  @override
  Widget build(BuildContext context) {
    final resize = Resize(context);

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(
              resize.px(25),
              resize.px(25),
              resize.px(25),
              resize.px(10),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Color(0xFF232323),
                fontSize: resize.px(17),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // bottom border
          MegaListItemBorder(),
        ],
      ),
    );
  }
}

// Item
class MegaSelectListItem extends HookWidget {
  // 图标
  @required
  final Widget thumb;

  // 主内容 Text | Widget
  @required
  final content;

  // 点击回调
  final Function onTap;

  // 箭头展示
  final bool arrow;

  MegaSelectListItem({
    this.thumb,
    this.content,
    this.onTap,
    this.arrow = true,
  });

  static Widget buildTitle(BuildContext context, String title) {
    final resize = Resize(context);

    return Text(
      title,
      style: TextStyle(
        fontSize: resize.px(15),
        fontWeight: FontWeight.bold,
        color: Color(0xFF555555),
      ),
    );
  }

  static Widget buildSubTitle(BuildContext context, String subTitle) {
    final resize = Resize(context);

    return Padding(
      padding: EdgeInsets.only(top: resize.px(7)),
      child: Text(
        subTitle,
        style: TextStyle(
          fontSize: resize.px(15),
          color: Color(0xFF999999),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 自适应尺寸
    final resize = Resize(context);

    return Container(
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: onTap ?? () {},
            child: // 内容主体
                Container(
              height: resize.px(77),
              padding: EdgeInsets.fromLTRB(
                resize.px(25),
                resize.px(13),
                resize.px(25),
                resize.px(13),
              ),
              child: Row(
                children: <Widget>[
                  // 图标
                  Container(
                    child: thumb,
                    width: resize.px(51),
                    height: resize.px(51),
                  ),
                  // 内容
                  Expanded(
                    flex: 6,
                    child: Container(
                      padding: EdgeInsets.only(left: resize.px(15)),
                      child: content is String
                          ? MegaSelectListItem.buildTitle(context, content)
                          : content,
                    ),
                  ),
                  // 箭头
                  arrow
                      ? Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              IconData(61570, fontFamily: 'MaterialIcons'),
                              color: Color(0xFFC6C6C6),
                              size: resize.px(14),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),

          // bottom border
          MegaListItemBorder(),
        ],
      ),
    );
  }
}
