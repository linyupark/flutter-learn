import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../utils/resize.dart';
import './item_border.dart';
import './item_select.dart';
import './item_title.dart';

// Header
class MegaInviteListHeader extends MegaSelectListHeader {
  final String title;

  MegaInviteListHeader({this.title});
}

// Item
class MegaInviteListItem extends HookWidget {
  // 图标
  @required
  final Widget thumb;

  @required
  final String telNo;

  // 日期 YYYY-MM-DD HH:mm
  final String datetime;

  // 金额变动
  final String amount;

  // 状态
  final String status;

  MegaInviteListItem({
    this.thumb,
    this.telNo,
    this.datetime,
    this.amount,
    this.status,
  });

  static Widget buildStatusIcon(BuildContext context, String status) {
    final resize = Resize(context);
    final iconMap = {
      "Active": {
        "id": 58959,
        "color": 0xFF6CC494,
      },
      "Inactive": {
        "id": 62420,
        "color": 0xFF00A0E9,
      },
      "Expired": {
        "id": 58933,
        "color": 0xFFC4C4C4,
      },
    };

    if (iconMap[status].isEmpty) {
      return null;
    }

    return Container(
      // width: resize.px(62),
      height: resize.px(18),
      margin: EdgeInsets.only(
        left: resize.px(6),
      ),
      padding: EdgeInsets.only(
        left: resize.px(3),
        right: resize.px(10),
      ),
      decoration: BoxDecoration(
        color: Color(iconMap[status]['color']),
        borderRadius: BorderRadius.all(
          Radius.circular(resize.px(9)),
        ),
      ),
      child: Container(
        child: Row(
          children: [
            Icon(
              IconData(
                iconMap[status]['id'],
                fontFamily: 'MaterialIcons',
              ),
              size: resize.px(14),
              color: Color(0xffffffff),
            ),
            Container(
              width: resize.px(5),
            ),
            Text(
              status,
              style: TextStyle(
                fontSize: resize.px(12),
                color: Color(0xffffffff),
              ),
            ),
          ],
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
          Container(
            height: resize.px(70),
            padding: EdgeInsets.fromLTRB(
              resize.px(25),
              0,
              resize.px(25),
              0,
            ),
            child: Row(
              children: <Widget>[
                // 图标
                Container(
                  child: thumb,
                  width: resize.px(30),
                  height: resize.px(30),
                ),
                // 内容
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(left: resize.px(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: resize.px(16),
                        ),
                        Row(
                          children: [
                            MegaListItemTitle(
                              title: telNo,
                            ),
                            MegaInviteListItem.buildStatusIcon(context, status),
                          ],
                        ),
                        Container(
                          height: resize.px(11),
                        ),
                        MegaListItemTitle(
                          title: datetime,
                          size: 12,
                          color: Color(0xFF555555),
                        ),
                      ],
                    ),
                  ),
                ),
                // 金额状态
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      amount ?? '--',
                      style: TextStyle(
                        color: Color(0xFF232323),
                        fontSize: resize.px(20),
                        height: 1,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          MegaListItemBorder(
            margin: EdgeInsets.only(
              left: resize.px(70),
              right: resize.px(25),
            ),
          )
        ],
      ),
    );
  }
}
