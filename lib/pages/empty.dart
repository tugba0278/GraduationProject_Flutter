import 'package:bitirme_projesi/pages/home_page.dart';
import 'package:bitirme_projesi/pages/oval_clipper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DonationListPage extends StatefulWidget {
  const DonationListPage({super.key});

  @override
  _DonationListPageState createState() => _DonationListPageState();
}

class _DonationListPageState extends State<DonationListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<DocumentSnapshot>> getUserDocs(String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Kullanıcının belgesini referans al
      DocumentReference userDocRef =
          firestore.collection('kan-ihtiyacı').doc(userId);

      // Kullanıcının belgesi var mı kontrol et
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      if (userDocSnapshot.exists) {
        // user-docs koleksiyonunu referans al
        CollectionReference userDocsCollectionRef =
            userDocRef.collection('user-docs');

        // Kullanıcının belgesi altındaki belgeleri al
        QuerySnapshot userDocsQuerySnapshot = await userDocsCollectionRef.get();

        // Belgeleri döndür
        return userDocsQuerySnapshot.docs;
      } else {
        print('Kullanıcının belgesi bulunamadı.');
        return [];
      }
    } catch (e) {
      print('Belgeler alınırken bir hata oluştu: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFEEE2DE),
        appBar: AppBar(
          backgroundColor: const Color(0xFFEEE2DE),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                size: 35), // Geri düğmesini büyütme
            onPressed: () {
              Navigator.pop(context); // Geri düğmesine basıldığında geri dön
            },
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Bağışta Bulunanlar'),
              Tab(text: 'Kan İhtiyacı Olanlar'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // İlk sekme içeriği
            Container(),
            // İkinci sekme içeriği
            FutureBuilder(
              future: getUserDocs(userId), // Kullanıcı belgelerini al
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('Veri bulunamadı'));
                } else {
                  // Kullanıcının belgeleri varsa
                  List<DocumentSnapshot<Object?>>? docs = snapshot.data;
                  return ListView.builder(
                    itemCount: docs?.length,
                    itemBuilder: (context, index) {
                      // Her bir belge için bir Card oluştur
                      return Card(
                        child: ListTile(
                          title:
                              Text('Donör İsmi: ${docs?[index]['donor-name']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kan Grubu: ${docs?[index]['blood-type']}'),
                              Text(
                                  'Telefon Numarası: ${docs?[index]['phone-number']}'),
                              Text(
                                  'Yaşadığı Şehir: ${docs?[index]['living-city']}'),
                              Text(
                                  'Yayınlanma Tarihi: ${docs?[index]['confirm-date']}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
