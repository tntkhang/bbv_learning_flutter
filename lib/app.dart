
import 'package:bbv_learning_flutter/screens/authen/authen_screen.dart';
import 'package:bbv_learning_flutter/screens/authen/bloc/authen_bloc.dart';
import 'package:bbv_learning_flutter/screens/authen/bloc/authen_state.dart';
import 'package:bbv_learning_flutter/screens/flash_screen.dart';
import 'package:bbv_learning_flutter/screens/home/home_screen.dart';
import 'package:bbv_learning_flutter/screens/setting_screen.dart';
import 'package:bbv_learning_flutter/screens/transaction_detail_screen.dart';
import 'package:bbv_learning_flutter/services/authen_repository.dart';
import 'package:bbv_learning_flutter/utils/screen_routes.dart';
import 'package:bbv_learning_flutter/utils/theme.dart';
import 'package:bbv_learning_flutter/utils/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  final AuthenRepository authenRepo;

  MyApp({Key? key, required this.authenRepo}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(),
        ),
        BlocProvider<AuthenBloc>(
          create: (_) => AuthenBloc(const AuthenState.unknow(), authenRepo),
        ),
      ],
      child: const AppView(),
    );
  }
}


class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeData>(
        builder: (_, theme) {
          return PlatformApp(
            title: 'Flutter Demo',
            localizationsDelegates: const [
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            routes: {
              ScreenRoutes.setting: (context) => const SettingScreen(),
              ScreenRoutes.itemDetail: (
                  context) => const TransactionDetailScreen(),
            },
            debugShowCheckedModeBanner: false,
            material: (_, __) =>
                MaterialAppData(
                  theme: theme,
                ),
            home: BlocListener<AuthenBloc, AuthenState>(
                listener: (context, state) {
                  switch (state.status) {
                    case AuthenStatus.authenticated:
                      const HomeScreen();
                      break;
                    default:
                      AuthenScreen();
                  }
                },
              child: AuthenScreen(),
            ),
          );
        }
    );
  }
}