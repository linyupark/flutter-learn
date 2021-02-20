import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import '../store/counter.dart';
import '../hooks/log_state.dart';
import '../hooks/time_alive.dart';
// import '../hooks/infinite_timer.dart';
import '../hooks/future_state.dart';

class HomePage extends HookWidget {
  final String username;
  HomePage({this.username});

  final when5 = when((_) => counter0.value >= 5, () => print('>= 5.'));

  @override
  Widget build(BuildContext context) {
    final loggedNum = useLogState(0);
    useTimeAliveHook(context);

    final controller =
        useAnimationController(duration: Duration(milliseconds: 800));

    // int timer = useInfiniteTimer(startNumber: 100);

    final requestBaidu = useFutureState(([params]) async {
      return await Dio().get("http://www.baidu.com");
    }, {
      'manual': true,
      'onSuccess': (data, params) {
        print(params);
        print('data: $data');
      }
    });

    final requestTaobao = useFutureState(([params]) async {
      return await Dio().get(
          'https://service-reyif0lj-1259108732.sh.apigw.tencentcs.com/release/dapi?_path=/tbk/dg.material.optional&q=钛金刚');
    }, {
      'defaultParams': {'name': 'taobao'}
    });

    // final disposeFixed5 = reaction(
    //     (_) => counter0.value, (num) => counter0.value = num >= 5 ? 5 : num);

    useEffect(() {
      print('requestTaobao.loading : ${requestTaobao.loading}');

      return () {
        // disposer();
        when5();
        // disposeFixed5();
      };
    }, [requestTaobao.data]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (requestTaobao.data != null)
              Text(requestTaobao.data.toString().substring(0, 100)),
            RotationTransition(
              turns: controller,
              child: ColoredBox(
                color: Colors.red,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Observer(
                    builder: (_) => Text(
                      // '${counter0.value} | $timer',
                      '${counter0.value}',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                counter0.increment();
                if (controller.isCompleted && controller.value == 1.000) {
                  controller.reset();
                }
                controller.animateTo(controller.value + .25);
                loggedNum.value++;
                requestBaidu.run();
              },
              child: Text(
                'Rotate',
                style: TextStyle(color: Colors.red),
              ),
            ),
            if (requestBaidu.loading) Text('loading...'),
            if (requestBaidu.data != null)
              Text(requestBaidu.data.toString().substring(0, 100)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.settings_backup_restore),
        onPressed: () {
          Navigator.pushReplacementNamed(context, 'login');
        },
      ),
    );
  }
}
