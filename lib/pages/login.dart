import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hello/router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../store/counter.dart';
import '../widgets/mega_toast.dart';
import '../widgets/mega_list/item_country.dart';
import '../widgets/mega_list/item_select.dart';
import '../widgets/mega_list/item_transaction.dart';

class LoginPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // Function _messageDispose = () {};

    return Observer(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text('Login'),
              ),
              body: ListView(
                children: [
                  MegaTransactionListHeader(
                    date: '2019 - 08',
                    expenditure: 0.00,
                    cashIn: 0.00,
                  ),
                  MegaTransactionListItem(
                    thumb: Image.network(
                      'http://linyu.dynv6.net:9001/images/icons/recent.jpeg',
                    ),
                    title: 'Shopping',
                    descript: 'Angeles Electnc Compa',
                    datetime: '2019-08-28 11:00',
                    amount: '-500',
                    status: 'Expired',
                  ),
                  MegaSelectListHeader(title: 'Select Payout Channel'),
                  MegaSelectListItem(
                    onTap: () {
                      print('hello');
                    },
                    content: 'Cash Pickup',
                    thumb: Image.network(
                      'http://linyu.dynv6.net:9001/images/icons/1614157053471.jpg',
                    ),
                  ),
                  MegaSelectListHeader(title: 'Recent'),
                  MegaSelectListItem(
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MegaSelectListItem.buildTitle(context, 'Zoe'),
                        MegaSelectListItem.buildSubTitle(
                            context, 'Cash Pickup - Robinsons Departq...'),
                      ],
                    ),
                    thumb: Image.network(
                      'http://linyu.dynv6.net:9001/images/icons/recent.jpeg',
                    ),
                    arrow: false,
                  ),
                  MegaCountryListItem(
                    thumb: Image.network(
                      'http://linyu.dynv6.net:9001/images/icons/country/china.png',
                    ),
                    name: 'China',
                    code: '+86',
                  ),
                  MegaCountryListItem(
                    thumb: Image.network(
                      'http://linyu.dynv6.net:9001/images/icons/country/china.png',
                    ),
                    name: 'China',
                    code: '+86',
                  ),
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
                      MegaToast.loading(context, 'Loading');
                      // MegaToast.custom(
                      //   context,
                      //   Card(
                      //     child: Padding(
                      //       // 文案框内边距
                      //       padding: EdgeInsets.all(12),
                      //       child: Text('hello'),
                      //     ),
                      //   ),
                      // );
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
                    },
                  )
                ],
              ),
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
