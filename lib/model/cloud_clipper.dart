import 'package:flutter/material.dart';

class CloudClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Bulut şeklini tanımlayacak path oluşturun
    Path path = Path();
    // Başlangıç noktası
    path.moveTo(size.width * 0.5, size.height * 0.1); // Yükseklik yüzde 10
    // Kontrol noktaları ve bitiş noktaları ekleyerek bir bulut şekli oluşturun
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.1,
      size.width * 0.2,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.4,
      size.width * 0.2,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.7,
      size.width * 0.3,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.9,
      size.width * 0.6,
      size.height * 0.85,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.9,
      size.width * 0.8,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.6,
      size.width * 0.7,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.3,
      size.width * 0.5, size.height * 0.1, // Yükseklik yüzde 10
    );
    // Path'i kapatın
    path.close();
    // Oluşturulan path'i döndürün
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // Clipper'ın yeniden kesilip kesilmeyeceğini belirtin
    return false;
  }
}
