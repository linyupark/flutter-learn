import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './pages/home.dart';
import './pages/login.dart';
import './pages/tab.dart';
import './pages/index.dart';

class AppRouter {
  static FluroRouter router = FluroRouter();
  static Handler _indexHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
        IndexPage(),
  );
  static Handler _loginHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
        LoginPage(),
  );
  static Handler _homeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
        HomePage(
      username: params['username'][0],
    ),
  );
  static Handler _tabHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
        TabPage(),
  );
  static void setup() {
    router.define(
      'index',
      handler: _indexHandler,
    );
    router.define(
      'login',
      handler: _loginHandler,
    );
    router.define(
      'home/:username',
      handler: _homeHandler,
    );
    router.define(
      'tab',
      handler: _tabHandler,
    );
  }
}
