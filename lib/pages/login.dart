import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hello/router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../store/counter.dart';
import '../widgets/mega_toast.dart';

class LoginPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // Function _messageDispose = () {};

    return Observer(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text('Login'),
              ),
              body: Center(
                  child: Column(
                children: [
                  Text(
                    'Login, global number: ${counter0.value}. ${counter0.username}',
                  ),
                  FlatButton(
                    onPressed: () {
                      counter0.value = 0;
                      // _messageDispose = MegaMessage.info(context, '计数器重置为0',
                      //     duration: 0, onClose: () {
                      //   MegaMessage.info(context, 'finished');
                      // });
                      // MegaToast.error(context, 'Loading Data Failed');
                      MegaToast.custom(
                        context,
                        Card(
                          child: Padding(
                            // 文案框内边距
                            padding: EdgeInsets.all(12),
                            child: Text('hello'),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'reset',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextFormField(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.person), labelText: 'Last Name'),
                      initialValue: counter0.user['lastName'],
                      onChanged: (v) {
                        counter0.user['lastName'] = v;
                      })
                ],
              )),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.exit_to_app),
                onPressed: () {
                  const username = 'linyu';
                  // _messageDispose();
                  // Navigator.pushNamed(context, 'home/$username');
                  AppRouter.router.navigateTo(context, 'home/$username',
                      transition: TransitionType.inFromRight, replace: true);
                },
              ),
            ));
  }
}
