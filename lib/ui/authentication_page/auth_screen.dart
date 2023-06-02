import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_login/flutter_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:scopr/ui/authentication_page/user_data_page.dart';

import '../home_page/home_page.dart';
import 'auth_controller.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  var controller = Get.put(AuthCustomController());

  @override
  Widget build(BuildContext context) {
    var userDetails = FirebaseAuth.instance;

    if (userDetails.currentUser != null) {
      if (userDetails.currentUser!.emailVerified) {
        controller.getUserData();
        return const HomePage();
      } else {
        // userDetails.currentUser!.sendEmailVerification();
        // FirebaseAuth.instance.signOut();
        // Fluttertoast.showToast(
        //     msg: "Confirm Your Email",
        //     toastLength: Toast.LENGTH_LONG,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
      }
    }
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
      ),
      home: Scaffold(
          body: FlutterLogin(
        theme: LoginTheme(
          pageColorLight: Colors.deepPurple,
          primaryColor: Colors.deepPurple,
        ),
        title: 'Scopr',
        logo: const AssetImage('assets/images/ScoprLogoTransparent.png'),
        onLogin: (login) async {
          var result = await controller.userSignIn(login);
          return result;
        },
        onSignup: (signup) async {
          var result = await controller.signUpUser(signup);
          if (result == "done") {
            Get.to(UserDataPage(
              signupData: signup,
            ));
          }
          return result;
        },
        onRecoverPassword: (string) async {
         await FirebaseAuth.instance.verifyPasswordResetCode(string);
          return "";
        },
      )),
    );
  }
}
