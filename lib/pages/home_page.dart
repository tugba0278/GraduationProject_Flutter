import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:bitirme_projesi/routes.dart';
import 'package:bitirme_projesi/utilities/dialogs/logout_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userName;

  late CustomVideoPlayerController _customVideoPlayerController;
  String assetPath = "assets/kan_bagisi.mp4";
  bool _isVideoPlayerInitialized = false;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
    loadUserName();
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVideoPlayerInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Yükleme animasyonu göster
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        // Boşluğa tıklandığında klavyeyi kapat
        FocusScope.of(context).unfocus();
        _searchFocus.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF5EF),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAF5EF),
          leading: Builder(
            builder: (context) => IconButton(
              color: Colors.black,
              iconSize: 50,
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
                _searchFocus.unfocus();
              },
            ),
          ),
          title: Container(
            padding: const EdgeInsets.only(
                right: 20, left: 10, top: 13, bottom: 3), // Sağ ve sol padding
            height: 60, // Arama çubuğunun yüksekliği
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              focusNode: _searchFocus,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Arama',
                hintStyle: const TextStyle(
                  fontSize: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: Color(0xFFCC4646), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: Color(0xFFCC4646), width: 2),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
        drawer: Drawer(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)),
          backgroundColor: const Color(0xFFFAF5EF),
          child: ListView.builder(
            itemCount: 8, // Menü öğelerinin sayısı
            itemBuilder: (context, index) {
              if (index == 0) {
                // İlk öğe: Resim
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Image.asset(
                    'lib/assets/drawer_img.png', // Resminizin yolunu belirtin
                    width: 150,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                );
              } else {
                // Diğer öğeler: Menü öğeleri
                IconData iconData;
                String title;
                switch (index) {
                  case 1:
                    iconData = Icons.account_circle;
                    title = "Kullanıcı Profili";
                    break;
                  case 2:
                    iconData = Icons.calendar_today;
                    title = 'Randevu Sistemi';
                    break;
                  case 3:
                    iconData = Icons.map;
                    title = 'Harita ve Yönlendirme';
                    break;
                  case 4:
                    iconData = Icons.info;
                    title = 'Bilgilendirme';
                    break;
                  case 5:
                    iconData = Icons.feedback;
                    title = 'Geri Bildirim Sistemi';
                    break;
                  case 6:
                    iconData = Icons.info_outline;
                    title = 'Hakkımızda';
                    break;
                  case 7:
                    iconData = Icons.exit_to_app;
                    title = 'Çıkış Yap';
                    break;
                  default:
                    iconData = Icons.circle;
                    title = 'Unknown';
                    break;
                }
                return ListTile(
                  leading: Icon(
                    iconData,
                    color: const Color(0xFF332C39),
                    size: 30,
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF696464),
                      fontFamily: "Times New Roman",
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () async {
                    if (index == 7) {
                      // Çıkış yap butonuna tıklandığında
                      final shouldLogout = await showLogOutDialog(context);
                      if (shouldLogout) {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginPageRoute,
                          (_) => false,
                        );
                      }
                    } else if (index == 4) {
                      Navigator.pushNamed(context, '/inform/');
                      print(
                          "index burada!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                      print(index);
                    }
                  },
                );
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                  height: 60), // Arama çubuğu ile video arasındaki boşluk
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10), // Sağ ve sol padding
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.grey), // Video çerçevesi için kenarlık
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomVideoPlayer(
                      customVideoPlayerController: _customVideoPlayerController,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                  height: 80), // Video ile butonlar arasındaki boşluk
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // İlk butona basıldığında yapılacak işlemler
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Color(0xFFCC4646),
                            width: 1.5,
                          ),
                        ),
                        minimumSize: const Size(150, 50),
                        elevation: 8),
                    child: const Text(
                      'Randevu',
                      style: TextStyle(
                          color: Color(0xFFCC4646),
                          fontFamily: "Times New Roman",
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // İkinci butona basıldığında yapılacak işlemler
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                          color: Color(0xFFCC4646),
                          width: 1.5,
                        ),
                      ),
                      minimumSize: const Size(150, 50),
                      elevation: 8,
                    ),
                    child: const Text(
                      'Harita',
                      style: TextStyle(
                          color: Color(0xFFCC4646),
                          fontFamily: "Times New Roman",
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 50), // Video ile butonlar arasındaki boşluk
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // İlk butona basıldığında yapılacak işlemler
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: Color(0xFFCC4646), width: 1.5),
                      ),
                      minimumSize: const Size(150, 50),
                      elevation: 8,
                    ),
                    child: const Text(
                      'Ödülünüz',
                      style: TextStyle(
                          color: Color(0xFFCC4646),
                          fontFamily: "Times New Roman",
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/inform/");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: Color(0xFFCC4646), width: 1.5),
                      ),
                      minimumSize: const Size(150, 50),
                      elevation: 8,
                    ),
                    child: const Text(
                      'Bilgilendirme',
                      style: TextStyle(
                          color: Color(0xFFCC4646),
                          fontFamily: "Times New Roman",
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 50), // Video ile butonlar arasındaki boşluk
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // İlk butona basıldığında yapılacak işlemler
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: Color(0xFFCC4646), width: 1.5),
                      ),
                      minimumSize: const Size(150, 50),
                      elevation: 8,
                    ),
                    child: const Text(
                      'Geri Bildirim Sistemi',
                      style: TextStyle(
                          color: Color(0xFFCC4646),
                          fontFamily: "Times New Roman",
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Kullanıcı adını Firestore'dan yükle
  void loadUserName() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userData = await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists) {
        setState(() {
          _userName = userData['name'];
        });
      } else {
        print('Kullanıcı verisi bulunamadı.');
      }
    } else {
      print('Kullanıcı girişi yapılmamış.');
    }
  }

  void initializeVideoPlayer() {
    late VideoPlayerController _videoPlayerController;
    _videoPlayerController = VideoPlayerController.asset(assetPath);
    _videoPlayerController.initialize().then((_) {
      setState(() {
        _customVideoPlayerController = CustomVideoPlayerController(
          context: context,
          videoPlayerController: _videoPlayerController,
        );
        _isVideoPlayerInitialized = true; // Video oynatıcı başarıyla başlatıldı
      });
    }).catchError((error) {
      // Video oynatıcı başlatma hatası
      setState(() {
        _isVideoPlayerInitialized = true; // Video oynatıcı başlatılamadı
      });
      print("Video oynatıcı başlatma hatası: $error");
      // Burada hata mesajı gösterilebilir
    });
  }
}
