import 'package:flutter/material.dart';
import 'package:flutter_back4app/ui/pages.dart';
import 'package:flutter_back4app/ui/screens/account_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    SplashScreen.routeName: (context) => SplashScreen(),
    HomeScreen.routeName: (context) => HomeScreen(),
    AccountScreen.routeName: (context) => AccountScreen(),
    SignInScreen.routeName: (context) => SignInScreen(),
    SignUpScreen.routeName: (context) => SignUpScreen(),
    TodoScreen.routeName: (context) => TodoScreen(),
  };
}
