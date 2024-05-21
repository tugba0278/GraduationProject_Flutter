import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bitirme_projesi/pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
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
        MaterialPageRoute(builder: (context) => const LoginUser()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF5EF),
      body: Container(
        //alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, 80), // Resmi 80 birim yukarı taşıdım
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
}
