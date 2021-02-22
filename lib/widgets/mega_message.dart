import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class _MessageWidget extends HookWidget {
  /// 入参部分

  // 消息内容
  final String content;
  // 消息类型 info,success,warn,error
  final String type;
  // 消息位置 0 - 100 相对视图高度
  final int vh;
  // 展示时长
  final int durationSec;

  _MessageWidget({
    this.content = '提示信息',
    this.type = 'info',
    this.vh = 50,
    this.durationSec,
  });

  @override
  Widget build(BuildContext context) {
    final int _ms = 200;
    final Duration _fadeInDuration = Duration(milliseconds: _ms);
    final AnimationController _controller =
        useAnimationController(duration: _fadeInDuration);
    useAnimation(Tween(begin: 0.0, end: 1.0).animate(_controller));
    _controller.forward();

    useEffect(() {
      // 淡出效果
      if (durationSec > 0) {
        Future.delayed(Duration(milliseconds: (durationSec * 1000 - _ms)))
            .then((_) {
          _controller.reset();
          // print(_controller.value);
        });
      }
      return () {};
    }, []);

    // 带阴影的消息内容box
    Container _messageContainer = Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(content),
        ),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 5.0,
          ),
        ],
      ),
    );

    return Positioned(
        top: MediaQuery.of(context).size.height * (vh / 100),
        child: Material(
          child: AnimatedOpacity(
            opacity: _controller.value,
            duration: _fadeInDuration,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Center(child: _messageContainer),
            ),
          ),
        ));
  }
}

class MegaMessage {
  static info(BuildContext context, String content,
      {int duration = 3, Function onClose}) {
    return _show(
        type: 'info',
        context: context,
        content: content,
        duration: duration,
        onClose: onClose);
  }

  static _show({
    @required String type,
    @required BuildContext context,
    @required String content,
    int duration = 3,
    Function onClose,
  }) {
    // 创建一个OverlayEntry对象
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => _MessageWidget(
            type: type, content: content, durationSec: duration));

    // 往Overlay中插入插入OverlayEntry
    Overlay.of(context).insert(overlayEntry);

    // 定义移除方法
    final removeOverlay = () {
      overlayEntry.remove();
      if (onClose != null) {
        onClose();
      }
    };

    /// 如果设置 0 则返回销毁信息的 disposer
    if (duration == 0) {
      print('return message.$type dispose');
      return removeOverlay;
    }

    Future.delayed(Duration(seconds: duration)).then((_) {
      removeOverlay();
    });
  }
}
