import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _diseaseController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _lastDonationController = TextEditingController();

  TextStyle textStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: "Times New Roman",
  );

  @override
  void dispose() {
    _contactInfoController.dispose();
    _addressController.dispose();
    _weightController.dispose();
    _bloodTypeController.dispose();
    _diseaseController.dispose();
    _birthDateController.dispose();
    _lastDonationController.dispose();
    super.dispose();
    super.dispose();
  }

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
          padding: EdgeInsets.only(left: 50),
          child: Text(
            'Kullanıcı Profili',
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
              padding: const EdgeInsets.only(left: 20, top: 35),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.zero),
                child: Image.asset(
                  'lib/assets/user_profile.png', // Resminizin yolunu belirtin
                  width: MediaQuery.of(context).size.width *
                      0.25, // Ekran genişliğinin %80'i kadar
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.only(left: 60, right: 40),
                child: Column(
                  children: [
                    _buildListTileWithUpdateButton(
                      title: 'İletişim Bilgileri',
                      fieldName:
                          'phoneNumber', // Kullanıcının telefon numarası buraya gelecek
                      onTap: () {
                        _showUpdateDialog(
                          context,
                          'İletişim Bilgileri',
                          'Yeni İletişim Bilgilerini Girin',
                          _contactInfoController,
                          'phoneNumber',
                        );
                      },
                    ),
                    _buildListTileWithUpdateButton(
                      title: 'Yaşadığınız Şehir',
                      fieldName:
                          'living-city', // Kullanıcının adres bilgisi buraya gelecek
                      onTap: () {
                        _showUpdateDialog(
                          context,
                          'Yaşadığınız Şehir',
                          'Yeni Adresi Girin',
                          _addressController,
                          'living-city',
                        );
                      },
                    ),
                    _buildListTileWithUpdateButton(
                      title: 'Kilo',
                      fieldName:
                          'kilo', // Kullanıcının kilo bilgisi buraya gelecek
                      onTap: () {
                        _showUpdateDialog(
                          context,
                          'Kilo',
                          'Yeni Kiloyu Girin',
                          _weightController,
                          'kilo',
                        );
                      },
                    ),
                    _buildListTileWithUpdateButton(
                      title: 'Kan Grubu',
                      fieldName:
                          'blood', // Kullanıcının kan grubu buraya gelecek
                      onTap: () {
                        _showUpdateDialog(
                          context,
                          'Kan Grubu',
                          'Yeni Kan Grubunu Girin',
                          _bloodTypeController,
                          'blood',
                        );
                      },
                    ),
                    _buildListTileWithUpdateButton(
                      title: 'Bulaşıcı Hastalık',
                      fieldName:
                          'diseaseInfo', // Kullanıcının bulaşıcı hastalığı bilgisi buraya gelecek
                      onTap: () {
                        _showUpdateDialog(
                          context,
                          'Bulaşıcı Hastalık',
                          'Bulaşıcı Hastalığı Girin',
                          _diseaseController,
                          'diseaseInfo',
                        );
                      },
                    ),
                    _buildListTileWithUpdateButton(
                      title: 'Doğum Tarihi',
                      fieldName:
                          'birthDate', // Kullanıcının doğum tarihi bilgisi buraya gelecek
                      onTap: () {
                        _showUpdateDialog(
                          context,
                          'Doğum Tarihi',
                          'Doğum Tarihini Girin',
                          _birthDateController,
                          'birthDate',
                        );
                      },
                    ),
                    _buildListTileWithUpdateButton(
                      title: 'En Son Kan Verme Tarihi',
                      fieldName:
                          'lastBloodDonation', // Kullanıcının en son kan verme tarihi bilgisi buraya gelecek
                      onTap: () {
                        _showUpdateDialog(
                          context,
                          'En Son Kan Verme Tarihi',
                          'En Son Kan Verme Tarihini Girin',
                          _lastDonationController,
                          'lastBloodDonation',
                        );
                      },
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildListTileWithUpdateButton({
    required String title,
    required String fieldName,
    required VoidCallback onTap,
  }) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            title: Text(
              title,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: const Text(
              'Yükleniyor...',
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: onTap,
          );
        }
        if (snapshot.hasError) {
          return ListTile(
            title: Text(
              title,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'Hata: ${snapshot.error}',
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: onTap,
          );
        }
        final data = snapshot.data!;
        String? subtitle = data[fieldName];
        if (subtitle == null || subtitle.isEmpty) {
          subtitle = 'Bilgi yok';
        }
        return ListTile(
          title: Text(
            title,
            style: textStyle,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context, String title, String hintText,
      TextEditingController controller, String fieldName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                controller.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Kaydet'),
              onPressed: () {
                _updateProfileInfo(fieldName, controller.text);
                controller.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateProfileInfo(String fieldName, String newValue) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    // Firestore'daki alanları güncelliyoruz
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      fieldName: newValue,
    }).then((_) {
      print('Firestore alanı güncellendi: $fieldName: $newValue');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF504658),
          content: Text('Profil bilgisi güncellendi'),
        ),
      );
    }).catchError((error) {
      print('Hata oluştu: $error');
    });
  }
}
