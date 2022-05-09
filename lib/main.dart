import 'package:bbv_learning_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const PlatformApp(
      title: 'Flutter Demo',
      home: HomeScreen(),
    );
  }
}
