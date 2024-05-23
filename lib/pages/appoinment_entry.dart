import 'package:bitirme_projesi/pages/appoinment_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentEntryPage extends StatefulWidget {
  const AppointmentEntryPage({Key? key});

  @override
  _AppointmentEntryPageState createState() => _AppointmentEntryPageState();
}

class _AppointmentEntryPageState extends State<AppointmentEntryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Randevular'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Güncel Randevularım'),
              Tab(text: 'Geçmiş Randevularım'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 40, bottom: 180),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppointmentPage()),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ),
            // First tab view
            FutureBuilder(
              future: returnUserName(),
              builder: (context, AsyncSnapshot<String> userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasError) {
                  return Center(child: Text('Error: ${userSnapshot.error}'));
                } else {
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('appoinments')
                        .doc(userSnapshot.data as String)
                        .get(),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        if (snapshot.data!.exists) {
                          List<dynamic> appointmentDates =
                              snapshot.data!['appoinmentdates'];
                          return ListView.builder(
                            itemCount: appointmentDates.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Text(appointmentDates[index]),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AppointmentEntryPage()),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text('No appointments found'),
                          );
                        }
                      }
                    },
                  );
                }
              },
            ),
            // Second tab view
            Scaffold(
              body: Center(child: Text('Geçmiş Randevularım İçeriği')),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> returnUserName() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  if (userDoc.exists) {
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    String? userName = userData['name'] as String?;
    if (userName != null) {
      return 'doc($userName)';
    } else {
      throw Exception('User name is null');
    }
  } else {
    throw Exception('User document does not exist');
  }
}
