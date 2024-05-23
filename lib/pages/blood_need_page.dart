import 'package:bitirme_projesi/pages/home_page.dart';
import 'package:bitirme_projesi/pages/oval_clipper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BloodNeedPage extends StatefulWidget {
  const BloodNeedPage({super.key});

  @override
  _BloodNeedPageState createState() => _BloodNeedPageState();
}

class _BloodNeedPageState extends State<BloodNeedPage> {
  late TextEditingController cityController = TextEditingController();
  String selectedCity = "";
  String selectedBloodType = "";
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

  late List<String> bloodTypes = [
    'A Rh+',
    'A Rh-',
    'B Rh+',
    'B Rh-',
    'AB Rh+',
    'AB Rh-',
    '0 Rh+',
    '0 Rh-',
  ];

  void addCityToFirestore(String city, String _bloodType) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    DateTime now = DateTime.now();
    String confirmDate = "${now.day}-${now.month}-${now.year}";

    if (user != null) {
      // Kullanıcının kimlik bilgisine dayalı olarak yeni bir belge ekleyin
      await firestore
          .collection('kan-ihtiyacı')
          .doc(user.uid)
          .collection('user-docs')
          .add({
        "donor-name": _userName,
        "blood-type": _bloodType,
        "phone-number": _phoneNumber,
        'living-city': city,
        'confirm-date': confirmDate,
      });
    } else {
      print("Kullanıcı oturumu açık değil.");
    }
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
        });
      } else {
        print('Kullanıcı verisi bulunamadı.');
      }
    } else {
      print('Kullanıcı girişi yapılmamış.');
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
              padding: EdgeInsets.only(top: 20.0, left: 10),
              child: Text(
                'Kan Bağışı Hayat Kurtarır',
                style: TextStyle(
                  fontFamily: "Times New Roman",
                  letterSpacing: 6,
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
                  'lib/assets/help.png', // Resminizin yolunu belirtin
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
                  height: 100, // Çerçevenin yüksekliği
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
                      'Ad soyad ve telefon numaranız paylaşılacaktır!',
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
              padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Kan Grubu :   ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    selectedBloodType.isEmpty ? 'Seç' : selectedBloodType,
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
                                // Kan listesini oluştur
                                ...bloodTypes.map((String bloodType) {
                                  return ListTile(
                                    titleAlignment:
                                        ListTileTitleAlignment.center,
                                    title: Text(bloodType),
                                    onTap: () {
                                      setState(() {
                                        selectedBloodType = bloodType;
                                      });
                                      Navigator.pop(context);
                                    },
                                    // Seçili kan varsayılan olarak "Seç" ise görsel olarak belirt
                                    selected: selectedBloodType == bloodType,
                                    tileColor: selectedBloodType == bloodType
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
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
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
                                // Şehir seçilmediğinde "Seç" yazısını görüntüle
                                if (selectedCity.isEmpty)
                                  ListTile(
                                    titleAlignment:
                                        ListTileTitleAlignment.center,
                                    title: const Text(
                                      'Seç',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedCity =
                                            ''; // Seçeneği seçildiğinde selectedCity'yi boşalt
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
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
                  if (selectedBloodType.isNotEmpty && selectedCity.isNotEmpty) {
                    addCityToFirestore(selectedCity, selectedBloodType);
                    print("gönderildi!!!!!!!!!!!!!!");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Geçmiş Olsun!"),
                          content: const Text(
                              "İhtiyacınız olan kan grubu talebiniz alındı."),
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
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                              "Kan Grubu ve Şehir Seçmek Zorunludur"),
                          content: const Text(
                              "Lütfen kan grubunuzu ve bir şehir seçiniz."),
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
