import 'package:bbv_learning_flutter/models/transaction_item.dart';
import 'package:bbv_learning_flutter/screens/home/home_screen.dart';
import 'package:bbv_learning_flutter/screens/setting_screen.dart';
import 'package:bbv_learning_flutter/screens/transaction_detail_screen.dart';
import 'package:bbv_learning_flutter/utils/screen_keys.dart';
import 'package:bbv_learning_flutter/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
        create: (BuildContext context) => ThemeNotifier(),
        child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: ScreenKeys.home,
      routes: {
        ScreenKeys.home: (context) => const HomeScreen(),
        ScreenKeys.setting: (context) => const SettingScreen(),
        ScreenKeys.itemDetail: (context) => const TransactionDetailScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: themeNotifier.getTheme(),
    );
  }
}
