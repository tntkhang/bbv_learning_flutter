// import 'package:bbv_learning_flutter/models/authen_model.dart';
// import 'package:bbv_learning_flutter/screens/authen/authen_cubit.dart';
// import 'package:bbv_learning_flutter/screens/authen/authen_screen.dart';
// import 'package:bbv_learning_flutter/screens/home/home_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
// import 'package:lottie/lottie.dart';
//
// import '../services/api_services.dart';
// import '../utils/preferences.dart';
//
// enum ScreenState {
//   LOADING,
//   SIGNED_IN,
//   SIGNED_OUT
// }
// class FlashScreen extends StatelessWidget {
//   // APISerivce apiService;
//   FlashScreen({Key? key,
//     // required this.apiService
//   }) : super(key: key);
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   Preferences().getAuthenToken().then((value) => _updateScreenState(value));
//   // }
//   //
//   // void _updateScreenState(String? authenIdToken) {
//   //   setState((){
//   //     screenState = (authenIdToken == null) ? ScreenState.SIGNED_OUT : ScreenState.SIGNED_IN;
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthenCubit, dynamic>(
//       builder: (context, state) {
//         switch (state) {
//           case ScreenState.LOADING:
//             _createFlashScreen();
//             break;
//           case ScreenState.SIGNED_IN:
//             const HomeScreen();
//             break;
//           case ScreenState.SIGNED_OUT:
//             AuthenScreen(apiSerivce: apiService);
//             break;
//         }
//       })
//     )
//   }
//
//   Widget _createFlashScreen() {
//     return PlatformScaffold(
//       body: Center(
//         child: SizedBox(
//           height:200,
//           width: 300,
//           child: Lottie.asset('assets/lottie/bicycle.json'),
//         ),
//       ),
//     );
//   }
// }
