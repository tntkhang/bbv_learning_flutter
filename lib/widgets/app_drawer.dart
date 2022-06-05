import 'package:bbv_learning_flutter/screens/home/home_screen.dart';
import 'package:bbv_learning_flutter/utils/screen_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/preferences.dart';

var currentScreen = const HomeScreen().toString();

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Center(child: Text('Expense Notes'), ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(title: const Align(
            alignment: Alignment.center,
            child: Text('Home'),
          ), onTap: () => _navScreen(context, ScreenRoutes.home)),
          ListTile(title: const Align(alignment: Alignment.center,
              child: Text('Settings')
          ), onTap: () => _navScreen(context, ScreenRoutes.setting)),
          ListTile(title: const Align(alignment: Alignment.center,
              child: Text('Logout')
          ), onTap: () => _logOut(context))
        ],
      ),
    );
  }

  void _logOut(BuildContext context) {
    Preferences().clearAuthenToken();
    _navScreen(context, ScreenRoutes.login);
  }

  _navScreen(BuildContext context, String pageName) {
    if (pageName != currentScreen) {
      currentScreen = pageName;
      return Navigator.pushReplacementNamed(context, pageName);
    }
  }
}
