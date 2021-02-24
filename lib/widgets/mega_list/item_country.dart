import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../utils/resize.dart';

class MegaCountryListItem extends HookWidget {
  // 国家国旗图标
  @required
  final Image thumb;

  // 国家名称（缩写）
  @required
  final String name;

  // +86
  @required
  final String code;

  MegaCountryListItem({
    this.thumb,
    this.name,
    this.code,
  });

  @override
  Widget build(BuildContext context) {
    // 自适应尺寸
    final resize = Resize(context);

    return Container(
      child: Column(
        children: <Widget>[
          // 内容主体
          Container(
            height: resize.px(55),
            padding: EdgeInsets.fromLTRB(
              resize.px(30),
              resize.px(25 / 2),
              resize.px(30),
              resize.px(25 / 2),
            ),
            child: Row(
              children: <Widget>[
                // 图标
                Container(
                  child: thumb,
                  width: resize.px(45),
                  height: resize.px(30),
                ),
                // 国家名称（缩写）
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.only(left: resize.px(16)),
                    child: Text(
                      name,
                      style: TextStyle(fontSize: resize.px(14)),
                    ),
                  ),
                ),
                // 手机区号
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      code,
                      style: TextStyle(fontSize: resize.px(14)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
