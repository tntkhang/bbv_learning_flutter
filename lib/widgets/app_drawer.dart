import 'package:bbv_learning_flutter/screens/home/home_screen.dart';
import 'package:bbv_learning_flutter/utils/screen_keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          ), onTap: () => _navScreen(context, ScreenKeys.home)),
          ListTile(title: const Align(alignment: Alignment.center,
              child: Text('Settings')
          ), onTap: () => _navScreen(context, ScreenKeys.setting))
        ],
      ),
    );
  }

  _navScreen(BuildContext context, String pageName) {
    if (pageName != currentScreen) {
      currentScreen = pageName;
      return Navigator.pushReplacementNamed(context, pageName);
    }
  }
}
