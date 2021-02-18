import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../store/counter.dart';

class HomePage extends HookWidget {
  final String username;
  HomePage({this.username});
  @override
  Widget build(BuildContext context) {
    final controller =
        useAnimationController(duration: Duration(milliseconds: 800));

    final when5 = when((_) => counter0.value >= 5, () => print('>= 5.'));

    final disposeFixed5 = reaction(
        (_) => counter0.value, (num) => counter0.value = num >= 5 ? 5 : num);

    useEffect(() {
      final disposer = autorun((_) {
        print('${counter0.value}');
      });

      return () {
        disposer();
        when5();
        disposeFixed5();
      };
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RotationTransition(
              turns: controller,
              child: ColoredBox(
                color: Colors.red,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Observer(
                    builder: (_) => Text(
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
              },
              child: Text(
                'Rotate',
                style: TextStyle(color: Colors.red),
              ),
            ),
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
