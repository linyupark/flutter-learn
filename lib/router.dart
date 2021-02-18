import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './pages/home.dart';
import './pages/login.dart';

class AppRouter {
  static FluroRouter router = FluroRouter();
  static Handler _loginHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LoginPage());
  static Handler _homeHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          HomePage(username: params['username'][0]));
  static void setup() {
    router.define(
      'login',
      handler: _loginHandler,
    );
    router.define(
      'home/:username',
      handler: _homeHandler,
    );
  }
}
