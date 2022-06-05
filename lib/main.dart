import 'package:bbv_learning_flutter/screens/authen/authen_screen.dart';
import 'package:bbv_learning_flutter/screens/flash_screen.dart';
import 'package:bbv_learning_flutter/screens/home/home_screen.dart';
import 'package:bbv_learning_flutter/screens/setting_screen.dart';
import 'package:bbv_learning_flutter/screens/transaction_detail_screen.dart';
import 'package:bbv_learning_flutter/utils/screen_routes.dart';
import 'package:bbv_learning_flutter/utils/theme.dart';
import 'package:flutter/cupertino.dart';
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
    return PlatformApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      initialRoute: ScreenRoutes.flash,
      routes: {
        ScreenRoutes.flash: (context) => const FlashScreen(),
        ScreenRoutes.home: (context) => const HomeScreen(),
        ScreenRoutes.login: (context) => const AuthenScreen(),
        ScreenRoutes.setting: (context) => const SettingScreen(),
        ScreenRoutes.itemDetail: (context) => const TransactionDetailScreen(),
      },
      debugShowCheckedModeBanner: false,
      material: (_, __) => MaterialAppData(
        theme: lightThemeData,
        darkTheme: darkThemeData,
        themeMode: themeNotifier.getTheme(),
      ),
    );
  }
}
