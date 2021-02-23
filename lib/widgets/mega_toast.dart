import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import './mega_hooks/spinner_hook.dart';

class _ToastWidget extends HookWidget {
  /// 入参部分

  // 消息内容
  final dynamic content;
  // 消息类型 info,success,error,loading,custom
  final String type;
  // 消息位置 0 - 100 相对视图高度
  final int vh;
  // 消息最大宽度
  final int vw;
  // 展示时长
  final int durationSec;

  _ToastWidget({
    this.content,
    this.type,
    this.vh,
    this.vw,
    this.durationSec,
  });

  @override
  Widget build(BuildContext context) {
    final int _ms = 200;

    final Duration _fadeInDuration = Duration(milliseconds: _ms);

    // 渐变动画控制器
    final AnimationController _fadeInController =
        useAnimationController(duration: _fadeInDuration)..forward();

    // 旋转动画控制器
    final AnimationController _repeatController =
        useAnimationController(duration: Duration(milliseconds: 1000));

    // 控制渐变起始数值
    useAnimation(Tween(begin: 0.0, end: 1.0).animate(_fadeInController));

    // 旋转图标
    RotationTransition spinnerIcon = useMegaSpinnerWidget(
      child: Icon(
        IconData(58834, fontFamily: 'MaterialIcons'),
        color: Colors.white,
        size: 40,
      ),
      repeatController: _repeatController,
    );

    useEffect(() {
      // 淡出效果
      if (durationSec > 0) {
        Future.delayed(Duration(milliseconds: (durationSec * 1000 - _ms)))
            .then((_) {
          _fadeInController.reset();
        });
      }
      return () {};
    }, []);

    // 不同类型信息内容展示
    dynamic _messageText;
    if (type != 'custom') {
      _messageText = Text(content, style: TextStyle(color: Colors.white));
    }

    if (type == 'loading') {
      _messageText = Column(children: [
        spinnerIcon,
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text(content, style: TextStyle(color: Colors.white)),
        ),
      ]);
    }

    if (type == 'success') {
      _messageText = Column(children: [
        Icon(
          IconData(0xe650, fontFamily: 'MaterialIcons'),
          color: Colors.white,
          size: 40,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text(content, style: TextStyle(color: Colors.white)),
        ),
      ]);
    }

    if (type == 'error') {
      _messageText = Column(children: [
        Icon(
          IconData(59137, fontFamily: 'MaterialIcons'),
          color: Colors.white,
          size: 40,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text(content, style: TextStyle(color: Colors.white)),
        ),
      ]);
    }

    // 带阴影的消息内容box
    Container _messageContainer = Container(
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * (vw / 100)),
      child: Card(
        color: Colors.black.withOpacity(.65),
        child: Padding(
          // 文案框内边距
          padding: EdgeInsets.all(12),
          child: _messageText,
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

    // 自定义内容
    if (type == 'custom') {
      _messageContainer = Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * (vw / 100)),
        child: content,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.2),
              blurRadius: 5.0,
            ),
          ],
        ),
      );
    }

    return Positioned(
      top: MediaQuery.of(context).size.height * (vh / 100),
      child: Material(
        child: AnimatedOpacity(
          opacity: _fadeInController.value,
          duration: _fadeInDuration,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(child: _messageContainer),
          ),
        ),
      ),
    );
  }
}

class MegaToast {
  // 自定义内容
  static custom(
    BuildContext context,
    Widget content, {
    int duration = 3,
    int vh,
    int vw,
    Function onClose,
  }) {
    return _show(
      type: 'custom',
      context: context,
      content: content,
      duration: duration,
      vw: vw,
      vh: vh,
      onClose: onClose,
    );
  }

  static loading(
    BuildContext context,
    String content, {
    int duration,
    Function onClose,
  }) {
    return _show(
      type: 'loading',
      context: context,
      content: content,
      duration: duration,
      onClose: onClose,
    );
  }

  static info(
    BuildContext context,
    String content, {
    int duration,
    Function onClose,
  }) {
    return _show(
      type: 'info',
      context: context,
      content: content,
      duration: duration,
      onClose: onClose,
    );
  }

  static success(
    BuildContext context,
    String content, {
    int duration,
    Function onClose,
  }) {
    return _show(
      type: 'success',
      context: context,
      content: content,
      duration: duration,
      onClose: onClose,
    );
  }

  static error(
    BuildContext context,
    String content, {
    int duration,
    Function onClose,
  }) {
    return _show(
      type: 'error',
      context: context,
      content: content,
      duration: duration,
      onClose: onClose,
    );
  }

  static _show({
    @required String type,
    @required BuildContext context,
    @required content,
    int vh,
    int vw,
    int duration,
    Function onClose,
  }) {
    duration = duration ?? 3;

    // 创建一个OverlayEntry对象
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        type: type,
        content: content,
        vh: vh ?? 30,
        vw: vw ?? 80,
        durationSec: duration,
      ),
    );

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
