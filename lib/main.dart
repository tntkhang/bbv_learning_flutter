import 'package:bbv_learning_flutter/models/transaction_item.dart';
import 'package:bbv_learning_flutter/screens/home_screen.dart';
import 'package:bbv_learning_flutter/screens/setting_screen.dart';
import 'package:bbv_learning_flutter/screens/transaction_detail_screen.dart';
import 'package:bbv_learning_flutter/utils/screen_keys.dart';
import 'package:bbv_learning_flutter/utils/theme.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

void main() {
  runApp(
    EasyDynamicThemeWidget(
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      title: 'Flutter Demo',
      initialRoute: ScreenKeys.home,
      routes: {
        ScreenKeys.home: (context) => const HomeScreen(),
        ScreenKeys.setting: (context) => const SettingScreen(),
        ScreenKeys.itemDetail: (context) => TransactionDetailScreen(),
      },
        material: (_, __)  => MaterialAppData(
          theme: lightThemeData,
          darkTheme: darkThemeData,
          themeMode: EasyDynamicTheme.of(context).themeMode,
        )
    );
  }
}
