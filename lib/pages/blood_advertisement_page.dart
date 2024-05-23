import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BloodAdvertisementPage extends StatefulWidget {
  const BloodAdvertisementPage({Key? key}) : super(key: key);

  @override
  _BloodAdvertisementPageState createState() => _BloodAdvertisementPageState();
}

class _BloodAdvertisementPageState extends State<BloodAdvertisementPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<DocumentSnapshot>> getAllUserNeedDocs(String userId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return [];
      }

      CollectionReference donationCollectionRef =
          FirebaseFirestore.instance.collection('kan-ihtiyacı');

      QuerySnapshot donationDocsQuerySnapshot =
          await donationCollectionRef.where('user-id', isEqualTo: userId).get();

      return donationDocsQuerySnapshot.docs;
    } catch (e) {
      print('Belgeler alınırken bir hata oluştu: $e');
      return [];
    }
  }

  Future<List<DocumentSnapshot>> getAllCompletedDocs(String userId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return [];
      }

      CollectionReference donationCollectionRef =
          FirebaseFirestore.instance.collection('karşılananlar');

      QuerySnapshot donationDocsQuerySnapshot =
          await donationCollectionRef.where('user-id', isEqualTo: userId).get();

      return donationDocsQuerySnapshot.docs;
    } catch (e) {
      print('Belgeler alınırken bir hata oluştu: $e');
      return [];
    }
  }

  Future<void> deleteDocumentByFields(
      String userId, Map<String, dynamic> fields) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('kan-ihtiyacı')
          .where('user-id', isEqualTo: userId)
          .where('donor-name', isEqualTo: fields['donor-name'])
          .where('blood-type', isEqualTo: fields['blood-type'])
          .where('phone-number', isEqualTo: fields['phone-number'])
          .where('living-city', isEqualTo: fields['living-city'])
          .where('confirm-date', isEqualTo: fields['confirm-date'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        await FirebaseFirestore.instance
            .collection('karşılananlar')
            .add(fields);
        print(
            'Doküman başarıyla silindi ve "karşılananlar" koleksiyonuna eklendi.');
        setState(() {}); // State'i güncellemek için setState kullanılıyor
      } else {
        print('Silinecek doküman bulunamadı.');
      }
    } catch (e) {
      print('Doküman silinirken bir hata oluştu: $e');
    }
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
            icon: const Icon(Icons.arrow_back, size: 35),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'İlan Verdiklerim'),
              Tab(text: 'Kan İhtiyacı Karşılanlar'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: getAllUserNeedDocs(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Veri bulunamadı'));
                } else {
                  List<DocumentSnapshot<Object?>>? docs = snapshot.data;
                  return ListView.builder(
                    itemCount: docs?.length,
                    itemBuilder: (context, index) {
                      var docData = docs?[index].data() as Map<String, dynamic>;
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 24.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Card(
                          margin: const EdgeInsets.all(7),
                          color: const Color(0xFFFCDDB0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                    'Alıcı İsmi: ${docData['donor-name']}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Kan Grubu: ${docData['blood-type']}'),
                                    Text(
                                        'Telefon Numarası: ${docData['phone-number']}'),
                                    Text(
                                        'Yaşadığı Şehir: ${docData['living-city']}'),
                                    Text(
                                        'Yayınlanma Tarihi: ${docData['confirm-date']}'),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  deleteDocumentByFields(userId, docData);
                                },
                                child: const Text('Karşılandı'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            FutureBuilder(
              future: getAllCompletedDocs(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Veri bulunamadı'));
                } else {
                  List<DocumentSnapshot<Object?>>? docs = snapshot.data;
                  return ListView.builder(
                    itemCount: docs?.length,
                    itemBuilder: (context, index) {
                      var docData = docs?[index].data() as Map<String, dynamic>;
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 24.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Card(
                          margin: const EdgeInsets.all(7),
                          color: Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                    'Alıcı İsmi: ${docData['donor-name']}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Kan Grubu: ${docData['blood-type']}'),
                                    Text(
                                        'Telefon Numarası: ${docData['phone-number']}'),
                                    Text(
                                        'Yaşadığı Şehir: ${docData['living-city']}'),
                                    Text(
                                        'Yayınlanma Tarihi: ${docData['confirm-date']}'),
                                  ],
                                ),
                              ),
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
