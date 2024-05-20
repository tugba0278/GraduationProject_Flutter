import 'package:bitirme_projesi/pages/inform.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bitirme_projesi/firebase_options.dart';
import 'package:bitirme_projesi/routes.dart';
import 'package:bitirme_projesi/pages/login_page.dart';
import 'package:bitirme_projesi/pages/register_page.dart';
import 'package:bitirme_projesi/pages/information_page.dart';
import 'package:bitirme_projesi/pages/home_page.dart';
import 'package:bitirme_projesi/pages/inform.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: loginPageRoute, // Set the initial route
      routes: {
        loginPageRoute: (context) => const LoginUser(),
        registerPageRoute: (context) => const RegisterUser(),
        informationPageRoute: (context) => const Information(),
        homePageRoute: (context) => const HomePage(),
        informPageRoute: (context) => const InformPage(),
      },
    );
  }
}
