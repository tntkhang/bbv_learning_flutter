import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/screen_routes.dart';
import './authen_bloc.dart';
import 'authen_event.dart';
import 'authen_state.dart';

class AuthenScreen extends StatefulWidget {
  const AuthenScreen({Key? key}) : super(key: key);

  @override
  State<AuthenScreen> createState() => _AuthenScreenState();
}

class _AuthenScreenState extends State<AuthenScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final bloc = AuthenBloc();
  var loadingAuthen = false;

  @override
  void initState() {
    super.initState();
    print('>>>>> _AuthenScreenState initState');
    bloc.stateController.stream.listen((event) {
      print('>>>>> stateController: ${event.toString()}');

      if (event.authenState == AState.LOADING) {
        loadingAuthen = true;
        setState(() {});
      } else if (event.authenState == AState.SIGNED_IN) {
        Navigator.pushReplacementNamed(context, ScreenRoutes.home);
      } else {
        Fluttertoast.showToast(
            msg: "Error: Login fail !",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        loadingAuthen = false;
        setState(() {});
      }
    });
  }

  void authenWithAccount() {
    var email = emailController.text;
    var password = passwordController.text;
    bloc.eventController.sink.add(LoginEvent(email, password));
  }
  void registerNewAccount(){
    var email = emailController.text;
    var password = passwordController.text;
    bloc.eventController.sink.add(SignUpEvent(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black,
                    Colors.black,
                    Colors.orange,
                    Colors.amber,
                  ]
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50,),
              SizedBox(
                height:200,
                width: 300,
                child: Lottie.asset('assets/lottie/login2.json'),
              ),
              const SizedBox(height: 10,),
              Container(
                width: 325,
                height: 420,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: loadingAuthen ? SizedBox(
                  child: Center (child: Lottie.asset('assets/lottie/leaf-loading-animation.json'),),
                  height: 100.0,
                  width: 100.0,
                ) : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20,),
                    const Text("BBV Viet Nam",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight:FontWeight.bold
                      ),),
                    const SizedBox(height: 10,),
                    const Text("Please Login to Your Account",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),),
                    const SizedBox(height: 30,),
                    Container(
                      width: 260,
                      height: 60,
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            suffix: Icon(FontAwesomeIcons.envelope,color: Colors.black,),
                            labelText: "Email Address",
                            labelStyle: TextStyle(
                                color: Colors.black
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 0.0),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.black ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.black ),
                            ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12,),
                    Container(
                      width: 260,
                      height: 60,
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                            suffix: Icon(FontAwesomeIcons.eyeSlash,color: Colors.black,),
                            labelText: "Password",
                          labelStyle: TextStyle(
                                color: Colors.black
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 0.0),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.black ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.black ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    GestureDetector(
                      onTap: authenWithAccount,
                      child: Container(
                        alignment: Alignment.center,
                        width: 250,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.black,
                                  Colors.amber,
                                ])
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Login',
                            style: TextStyle(color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 17 ,),
                    GestureDetector(
                      onTap: registerNewAccount,
                      child: Container(
                        alignment: Alignment.center,
                        width: 250,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            border: Border.all(color: Colors.amber),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Register new account',
                            style: TextStyle(color: Colors.amber,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
