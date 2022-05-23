import 'package:bbv_learning_flutter/screens/home_screen.dart';
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
            child: Center(child: Text('Expense Notes')),
          ),
          ListTile(title: const Text('Home'), onTap: () => _navScreen(context, ScreenKeys.home)),
          ListTile(title: const Text('Settings'), onTap: () => _navScreen(context, ScreenKeys.setting))
        ],
      ),
    );
  }

  _navScreen(BuildContext context, String pageName) {
    Navigator.pop(context);
    if (pageName != currentScreen) {
      currentScreen = pageName;
      return Navigator.pushNamed(context, pageName);
    }
  }
}
