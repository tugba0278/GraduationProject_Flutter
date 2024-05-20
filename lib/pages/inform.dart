import 'package:flutter/material.dart';

class InformPage extends StatefulWidget {
  const InformPage({super.key});

  @override
  _InformPageState createState() => _InformPageState();
}

class _InformPageState extends State<InformPage> {
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
          padding: EdgeInsets.only(left: 60),
          child: Text(
            'Bilgilendirme',
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
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text(
                'Kan Alışverişi Nasıl Gerçekleşir?',
                style: TextStyle(
                  color: Color(0xFF4A403A),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'lib/assets/kan_alisveris.jpg', // Resminizin yolunu belirtin
                  width: MediaQuery.of(context).size.width *
                      0.8, // Ekran genişliğinin %80'i kadar
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Metni dikey olarak ortalama
                children: [
                  const Text(
                    'Kimler Kan Bağışı Yapabilir?',
                    style: TextStyle(
                      color: Color(0xFF4A403A),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Metni yatayda sola dayalı hizala
                    children: [
                      Text(
                        '1. 18-65 yaş aralığında ve 50 kg üzerinde ağırlığa sahip olanlar.',
                        style: textStyle,
                      ),
                      Text(
                        '2. Önceki bağışından bu yana en az 3 ay geçmiş olanlar.',
                        style: textStyle,
                      ),
                      Text(
                        '3. Sağlıklı hisseden ve herhangi bir hastalık ya da ilaç kullanımı bulunmayanlar.',
                        style: textStyle,
                      ),
                      Text(
                        '4. Gebelik dönemi dışında olanlar.',
                        style: textStyle,
                      ),
                      Text(
                        '5. Kan bağışı yapmadan önce dengeli bir şekilde beslenenler.',
                        style: textStyle,
                      ),
                      Text(
                        '6. Kan bağışı yaparken belirli bir süre aç kalmayanlar.',
                        style: textStyle,
                      ),
                      Text(
                        '7. Genel sağlık durumu iyi olanlar.',
                        style: textStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Kan Bağışı Yaparken Nelere Dikkat Etmeliyiz?',
                    style: TextStyle(
                      color: Color(0xFF4A403A),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1. Bağıştan önce yeterince dinlenmek ve uyumak önemlidir.',
                        style: textStyle,
                      ),
                      Text(
                        '2. Bol su içmek kan akışını artırabilir ve bağışı kolaylaştırabilir.',
                        style: textStyle,
                      ),
                      Text(
                        '3. Bağıştan önce demir içeren gıdalar tüketmek kan hacmini artırabilir.',
                        style: textStyle,
                      ),
                      Text(
                        '4. Bağış esnasında rahat bir pozisyon almak ve gevşemek önemlidir.',
                        style: textStyle,
                      ),
                      Text(
                        '5. Kan bağışı sonrasında yeterince sıvı almak ve dinlenmek önemlidir.',
                        style: textStyle,
                      ),
                      const SizedBox(height: 40),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFBCE0DA),
                          borderRadius:
                              BorderRadius.circular(15), // Köşe yuvarlama
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'lib/assets/warning.png',
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Kan Vermeyi İhmal Etmeyelim!',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF921224)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
