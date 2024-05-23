import 'package:bitirme_projesi/firebase_options.dart';
import 'package:bitirme_projesi/pages/home_page.dart';
import 'package:bitirme_projesi/pages/information_page.dart';
import 'package:bitirme_projesi/services/cloud_database/cloud_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bitirme_projesi/pages/login_page.dart';

bool isFilledForm = false;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadDiseaseInfo();

    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 3), // Geçiş süresini 3 saniyeye çıkardım
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves
            .easeInOut, // Geçişin yumuşaklığını artırmak için Curves.easeInOut kullandım
      ),
    );
    _controller.forward();
    Timer(const Duration(seconds: 4), () {
      // Splash ekranın gösterim süresini 5 saniyeye çıkardım
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PreHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5EF),
      body: Container(
        //alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, 80), // Resmi 80 birim yukarı taşıdım
              child: ScaleTransition(
                scale: _animation,
                child: Transform.scale(
                  scale: 0.4,
                  child: Image.asset(
                    'lib/assets/crescent.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Text(
              'Uygulamamıza hoş geldiniz!\n',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times New Roman",
                  color: Color(0xFF420000)),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Kan bağışı yaparak ihtiyaç sahiplerine umut olalım.',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times New Roman",
                  color: Color(0xFF672F2F)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void loadDiseaseInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await _firestoreInstance
          .collection(usersCollectionName)
          .doc(user.uid)
          .get();
      if (userData.exists) {
        setState(() {
          if (userData[diseaseInfoFieldName] == "Evet" ||
              userData[diseaseInfoFieldName] == "Hayır") {
            isFilledForm = true;
          }
        });
      } else {
        print('Kullanıcı hastalık bilgisi bulunamadı.');
      }
    } else {
      print('Kullanıcı girişi yapılmamış.');
    }
  }
}

class PreHomePage extends StatelessWidget {
  const PreHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (isFilledForm) {
                return const HomePage();
              }
              return const InformationPage();
            } else {
              return const LoginUserPage();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
