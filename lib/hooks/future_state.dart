import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void _onSuccess(data, params) {}
void _onError(e, params) {}

// 状态加手动执行函数
class FutureState {
  final dynamic data;
  final bool loading;
  final Function run;

  const FutureState(this.data, this.loading, this.run);
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
  dynamic data;
  bool loading = false;
  Function run;

  @override
  void initHook() {
    super.initHook();
    // 默认数据
    data = hook.options['initialData'];

    // 手动执行函数
    run = ([params]) async {
      final runParams = params ?? hook.options['defaultParams'];
      setState(() {
        loading = true;
      });
      try {
        dynamic result = await hook.futureFunc(runParams);
        // print('future run $runParams');
        setState(() {
          loading = false;
          data = result;
        });
        hook.options['onSuccess'](data, runParams);
      } catch (e) {
        hook.options['onError'](e, runParams);
      }
    };

    // 非手动自动执行
    if (hook.options['manual'] == false) {
      run();
    }
  }

  @override
  build(BuildContext context) {
    return FutureState(data, loading, run);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
