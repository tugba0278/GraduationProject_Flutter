import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  TextStyle textStyle =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEE2DE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB7B7B7),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, size: 35), // Geri düğmesini büyütme
          onPressed: () {
            Navigator.pop(context); // Geri düğmesine basıldığında geri dön
          },
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Text(
            'Hakkımızda',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFF504658),
                fontFamily: "Times New Roman",
                fontWeight: FontWeight.w900),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50, top: 35),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.zero),
                child: Image.asset(
                  'lib/assets/blood-donation.png', // Resminizin yolunu belirtin
                  width: MediaQuery.of(context).size.width *
                      0.5, // Ekran genişliğinin %80'i kadar
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50.0, left: 17, right: 17),
              child: Text(
                'Neyi Amaçlıyoruz?',
                style: TextStyle(
                  color: Color(0xFF4A403A),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50.0, left: 30, right: 30),
              child: Text(
                'Kan Bağışı Uygulaması, kan bağışının önemini vurgulayarak daha fazla insanı bu değerli eyleme teşvik etmeyi amaçlar. Kullanıcılar, kan bağışı yapabilecekleri yerleri bulabilir, bağış tarihlerini takip edebilir ve toplumlarını güçlendirebilirler. Kolaylıkla kan vermek isteyen ve kan ihtiyacı bulunan kişilere ulaşabilmek mümkündür.',
                style: TextStyle(
                  color: Color(0xFF4A403A),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 35, right: 25),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.zero),
                child: Image.asset(
                  'lib/assets/donate.png', // Resminizin yolunu belirtin
                  width: MediaQuery.of(context).size.width *
                      0.175, // Ekran genişliğinin %80'i kadar
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
