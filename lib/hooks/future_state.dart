import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void _onSuccess(data, params) {}
void _onError(e, params) {}

// 状态加手动执行函数
class FutureState {
  dynamic data;
  bool loading;
  Function run;

  FutureState({this.loading});
}

// hook 函数
FutureState useFutureState(
  Function futureFunc, [
  Map<String, dynamic> options,
]) {
  Map<String, dynamic> _mergedOptions = {
    'manual': false,
    'defaultParams': {},
    'initialData': null,
    'onSuccess': _onSuccess,
    'onError': _onError,
  };
  // 合并参数
  _mergedOptions.addEntries((options ?? {}).entries);
  return use(_FutureFunc(futureFunc, _mergedOptions));
}

class _FutureFunc extends Hook<FutureState> {
  const _FutureFunc(this.futureFunc, this.options);

  final Function futureFunc;
  final Map<String, dynamic> options;

  @override
  _FutureFuncState createState() => _FutureFuncState();
}

class _FutureFuncState extends HookState<FutureState, _FutureFunc> {
  FutureState result = FutureState(loading: false);

  @override
  void initHook() {
    super.initHook();
    // 默认数据
    result.data = hook.options['initialData'];

    // 手动执行函数
    result.run = ([params]) async {
      final runParams = params ?? hook.options['defaultParams'];
      result.loading = true;
      try {
        result.data = await hook.futureFunc(runParams);
        // print('future run $runParams');
        result.loading = false;
        hook.options['onSuccess'](result.data, runParams);
      } catch (e) {
        hook.options['onError'](e, runParams);
      } finally {
        setState(() {
          result.loading = false;
        });
      }
    };

    // 非手动自动执行
    if (hook.options['manual'] == false) {
      result.run();
    }
  }

  @override
  build(BuildContext context) {
    return result;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
