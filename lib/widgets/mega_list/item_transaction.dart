import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../utils/resize.dart';
import './item_border.dart';
import './item_title.dart';

// Header
class MegaTransactionListHeader extends HookWidget {
  // 时间 YYYY-MM
  @required
  final String date;

  // 费用
  @required
  final double expenditure;

  // 收入
  @required
  final double cashIn;

  MegaTransactionListHeader({
    this.date,
    this.expenditure,
    this.cashIn,
  });

  @override
  Widget build(BuildContext context) {
    final resize = Resize(context);

    final cashTextStyle = TextStyle(
      color: Color(0xFF999999),
      fontSize: resize.px(12),
    );

    return Container(
      height: resize.px(58),
      color: Color(0xFFF6F6F6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date
          Container(
            margin: EdgeInsets.only(
              left: resize.px(25),
            ),
            decoration: BoxDecoration(
              color: Color(0xfffffffff),
              borderRadius: BorderRadius.all(
                Radius.circular(resize.px(14)),
              ),
            ),
            child: Container(
              height: resize.px(28),
              width: resize.px(100),
              child: Container(
                padding: EdgeInsets.only(
                  left: resize.px(15),
                  right: resize.px(5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(date),
                    Icon(
                      IconData(60242, fontFamily: 'MaterialIcons'),
                      color: Color(0xFFAFB2BC),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // cash
          Container(
            height: resize.px(36),
            padding: EdgeInsets.only(right: resize.px(25)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Expenditure NTD $expenditure', style: cashTextStyle),
                Container(
                  height: resize.px(6),
                ),
                Text('Cash in NTD $cashIn', style: cashTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Item
class MegaTransactionListItem extends HookWidget {
  // 图标
  @required
  final Widget thumb;

  // 交易标题
  @required
  final String title;

  // 交易描述
  final String descript;

  // 日期 YYYY-MM-DD HH:mm
  final String datetime;

  // 金额变动
  final String amount;

  // 交易状态
  final String status;

  // 最后一个
  final bool last;

  MegaTransactionListItem({
    this.thumb,
    this.title,
    this.descript,
    this.datetime,
    this.amount,
    this.status,
    this.last = false,
  });

  static Widget buildDescript(BuildContext context, String descript) {
    final resize = Resize(context);

    return Padding(
      padding: EdgeInsets.only(top: resize.px(7)),
      child: Text(
        descript,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: resize.px(12),
          color: Color(0xFF555555),
          height: 1,
        ),
      ),
    );
  }

  static Widget buildDate(BuildContext context, String date) {
    final resize = Resize(context);

    return Padding(
      padding: EdgeInsets.only(top: resize.px(5)),
      child: Text(
        date,
        style: TextStyle(
          fontSize: resize.px(11),
          color: Color(0xFF999999),
          height: 1,
        ),
      ),
    );
  }

  static Widget buildStatusIcon(BuildContext context, String status) {
    final resize = Resize(context);
    final iconMap = {
      "Completed": {
        "id": 58960,
        "color": 0xFF6CC494,
      },
      "Awaiting payment": {
        "id": 61094,
        "color": 0xFF00A0E9,
      },
      "Fail": {
        "id": 62069,
        "color": 0xFFFF2B06,
      },
      "Expired": {
        "id": 59527,
        "color": 0xFFF5963A,
      },
      "Ready for plckup": {
        "id": 58942,
        "color": 0xFF279E90,
      },
      "In Progress": {
        "id": 58177,
        "color": 0xFF437DD9,
      }
    };

    if (iconMap[status].isEmpty) {
      return null;
    }

    return Icon(
      IconData(iconMap[status]['id'], fontFamily: 'MaterialIcons'),
      color: Color(iconMap[status]['color']),
      size: resize.px(13),
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
            height: resize.px(77),
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
                  width: resize.px(32),
                  height: resize.px(32),
                ),
                // 内容
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(left: resize.px(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: resize.px(17),
                        ),
                        MegaListItemTitle(title: title),
                        MegaTransactionListItem.buildDescript(
                            context, descript),
                        MegaTransactionListItem.buildDate(context, datetime),
                      ],
                    ),
                  ),
                ),
                // 金额状态
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        amount ?? '--',
                        style: TextStyle(
                          color: Color(0xFF232323),
                          fontSize: resize.px(20),
                          height: 1,
                        ),
                      ),
                      Container(
                        height: resize.px(20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MegaTransactionListItem.buildStatusIcon(
                            context,
                            status,
                          ),
                          Container(width: resize.px(2)),
                          Text(
                            status,
                            style: TextStyle(
                              color: Color(0xFF999999),
                              height: 1,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          last
              ? null
              : MegaListItemBorder(
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
