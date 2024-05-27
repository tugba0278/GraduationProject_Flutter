import 'package:bitirme_projesi/pages/home_page.dart';
import 'package:bitirme_projesi/model/oval_clipper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BloodDonationPage extends StatefulWidget {
  const BloodDonationPage({super.key});

  @override
  _BloodDonationPageState createState() => _BloodDonationPageState();
}

class _BloodDonationPageState extends State<BloodDonationPage> {
  late TextEditingController cityController = TextEditingController();
  String selectedCity = "";
  String _userName = "";
  String _phoneNumber = "";
  String _bloodType = "";
  late List<String> cities = [
    'İstanbul',
    'Ankara',
    'İzmir',
    'Bursa',
    "Adana",
    "Adıyaman",
    "Antalya",
    "AfyonKarahisar",
    "Bitlis",
    "Denizli",
    "Isparta",
    "Burdur",
    "Muş",
    "Kars",
    "Elazığ",
    "Osmaniye",
    "Mardin",
  ]..sort();

  void addCityToFirestore(String city) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    DateTime now = DateTime.now();
    String confirmDate = "${now.day}-${now.month}-${now.year}";

    final DocumentReference docRef =
        firestore.collection('kan-verme').doc(user!.uid);

    await docRef.set({
      "donor-name": _userName,
      "blood-type": _bloodType,
      "phone-number": _phoneNumber,
      'living-city': city,
      'confirm-date': confirmDate,
    });
  }

  // Kullanıcı adını Firestore'dan yükle
  void loadFieldsData() async {
    final user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    if (user != null) {
      final userData = await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists) {
        setState(() {
          _userName = userData['name'];
          _phoneNumber = userData['phoneNumber'];
          _bloodType = userData['blood'];
        });
      } else {
        print('Kullanıcı verisi bulunamadı.');
      }
    } else {
      print('Kullanıcı girişi yapılmamış.');
    }
  }

  void updateLivingCity() async {
    if (selectedCity.isNotEmpty) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Kullanıcının verilerini güncelle
      await _firestore.collection('users').doc(userId).update({
        'living-city': selectedCity,
      });
      print("şehir seçildi!!!!!!!!!!!!");
    } else {
      print("selectedcity is empty!!!!!!!");
    }
  }

  @override
  void initState() {
    super.initState();
    loadFieldsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEE2DE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEE2DE),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, size: 35), // Geri düğmesini büyütme
          onPressed: () {
            Navigator.pop(context); // Geri düğmesine basıldığında geri dön
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 10, right: 10),
              child: Text(
                'Kan Bağışı Hayat Kurtarır',
                style: TextStyle(
                  fontFamily: "Times New Roman",
                  letterSpacing: 5,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 207, 176, 84),
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'lib/assets/donor.png', // Resminizin yolunu belirtin
                  width: MediaQuery.of(context).size.width *
                      0.4, // Ekran genişliğinin %80'i kadar
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              alignment: Alignment.center, // Container'ı ortala
              child: ClipOval(
                clipper: OvalClipper(),
                child: Container(
                  width: 250, // Çerçevenin genişliği
                  height: 130, // Çerçevenin yüksekliği
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF4A403A), // Çerçevenin arka plan rengi
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Ad soyad, kan grubunuz ve telefon numaranız paylaşılacaktır!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Yaşadığınız Şehir :   ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    selectedCity.isEmpty ? 'Seç' : selectedCity,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.5,
                            padding: const EdgeInsets.all(10.0),
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                // Şehir listesini oluştur
                                ...cities.map((String city) {
                                  return ListTile(
                                    titleAlignment:
                                        ListTileTitleAlignment.center,
                                    title: Text(city),
                                    onTap: () {
                                      setState(() {
                                        selectedCity = city;
                                        cityController.text = selectedCity;
                                      });
                                      Navigator.pop(context);
                                    },
                                    // Seçili şehir varsayılan olarak "Adana" ise görsel olarak belirt
                                    selected: selectedCity == city,
                                    tileColor: selectedCity == city
                                        ? Colors.blueGrey.withOpacity(0.2)
                                        : null,
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: ElevatedButton(
                onPressed: () {
                  if (selectedCity.isNotEmpty) {
                    addCityToFirestore(selectedCity);
                    print("gönderildi!!!!!!!!!!!!!!");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title:
                              const Text("Bağışınızla Bir Hayat Kurtardınız!"),
                          content: const Text("Teşekkürlerimizi sunarız."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomePage()));
                              },
                              child: const Text("Tamam"),
                            ),
                          ],
                        );
                      },
                    );
                    updateLivingCity();
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Şehir Seçmek Zorunludur"),
                          content: const Text("Lütfen bir şehir seçiniz."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Tamam"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(
                      color: Color(0xFF525252),
                      width: 1.5,
                    ),
                  ),
                  minimumSize: const Size(140, 45),
                  elevation: 8,
                ),
                child: const Text(
                  'Onayla',
                  style: TextStyle(
                    color: Color(0xFF525252),
                    fontFamily: "Times New Roman",
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
