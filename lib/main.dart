import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scopr/firebase_options.dart';
import 'package:scopr/ui/authentication_page/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.system,
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      hintColor: Colors.indigo.shade200,
      canvasColor: Colors.deepPurple.shade200,
      primaryColor: Colors.white,
      splashColor: const Color.fromRGBO(0, 0, 0, 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 8,
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          minimumSize: const Size.square(80),
        ),
      ),
    ),
    home: const AuthenticationPage(),
  );
}
