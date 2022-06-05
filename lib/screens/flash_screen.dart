import 'package:bbv_learning_flutter/models/authen_model.dart';
import 'package:bbv_learning_flutter/screens/authen/authen_screen.dart';
import 'package:bbv_learning_flutter/screens/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';

import '../utils/preferences.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({Key? key}) : super(key: key);

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

enum ScreenState {
  LOADING,
  SIGNED_IN,
  SIGNED_OUT
}
class _FlashScreenState extends State<FlashScreen> {
  var screenState = ScreenState.LOADING;

  @override
  void initState() {
    super.initState();
    Preferences().getAuthenToken().then((value) => _updateScreenState(value));
  }

  void _updateScreenState(String? authenIdToken) {
    setState((){
      screenState = (authenIdToken == null) ? ScreenState.SIGNED_OUT : ScreenState.SIGNED_IN;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (screenState) {
      case ScreenState.LOADING:
        return _createFlashScreen();
      case ScreenState.SIGNED_IN:
        return const HomeScreen();
      case ScreenState.SIGNED_OUT:
        return const AuthenScreen();
    }
  }

  Widget _createFlashScreen() {
    return PlatformScaffold(
      body: Center(
        child: SizedBox(
          height:200,
          width: 300,
          child: Lottie.asset('assets/lottie/bicycle.json'),
        ),
      ),
    );
  }
}
