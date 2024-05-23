import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
          padding: EdgeInsets.only(left: 40),
          child: Text(
            'Randevu Takvimi',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFF504658),
                fontFamily: "Times New Roman",
                fontWeight: FontWeight.w900),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDay =
                null; // Boş bir yere tıklandığında seçilen tarihi sil
          });
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: TableCalendar(
                  calendarStyle: const CalendarStyle(
                    cellMargin: EdgeInsets.all(8.0),
                    defaultTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      // Eğer seçilen gün zaten varsa, işlemi gerçekleştirme
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      }
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  // Yeni eklendi: Tarih bugünden önceyse seçilmemesini sağla
                  enabledDayPredicate: (day) {
                    return !day.isBefore(
                        DateTime.now().subtract(const Duration(days: 1)));
                  },
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, bottom: 160),
                  child: FloatingActionButton(
                    onPressed: () {
                      if (_selectedDay != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Randevu Tarihi'),
                              content: Text(
                                'Seçilen tarih: ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('İptal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _saveAppointmentToDatabase(_selectedDay!);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Kaydet'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Lütfen bir tarih seçin.'),
                          backgroundColor: Color(0xFF504658),
                        ));
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveAppointmentToDatabase(DateTime appointmentDate) {
    print('Randevu Tarihi: $appointmentDate');
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Kullanıcı adını Firestore'dan alarak randevu belgesini oluşturun veya güncelleyin
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((userDoc) {
      if (userDoc.exists) {
        String userName = userDoc.data()!['name']; // Kullanıcı adını al
        String documentId =
            userName; // Belge ID'si olarak kullanıcı adını ayarla

        // Firestore'dan randevu belgesini alın
        DocumentReference appointmentRef = FirebaseFirestore.instance
            .collection('appointments')
            .doc(documentId);

        appointmentRef.get().then((docSnapshot) {
          if (docSnapshot.exists) {
            // Belge zaten varsa, randevu tarihlerini kontrol et
            dynamic data = docSnapshot.data();
            if (data != null) {
              List<dynamic> appointmentTimestamps = data['appointment_dates'];

              // Seçilen tarih ile aynı tarihe sahip bir randevu var mı kontrol et
              bool appointmentExists = appointmentTimestamps.any((timestamp) {
                DateTime dateTime = (timestamp as Timestamp).toDate();
                return isSameDay(dateTime, appointmentDate);
              });

              // Seçilen tarih zaten bir randevu tarihinde mi kontrol et
              if (appointmentExists) {
                // Seçilen tarih zaten bir randevu tarihinde olduğu için kullanıcıya mesaj göster
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text('Bu tarihte zaten bir randevunuz bulunmaktadır.'),
                  backgroundColor: Color(0xFF504658),
                ));
              } else {
                // Belge zaten varsa ve seçilen tarih bir randevu tarihinde değilse, güncelle
                appointmentRef.update({
                  // Yeni tarihi eklemek için bir alan oluşturun
                  'appointment_dates': FieldValue.arrayUnion([appointmentDate]),
                  // İstediğiniz ek alanları ekleyin veya güncelleyin
                }).then((value) {
                  print(
                      'Appointment updated in Firestore with ID: $documentId');
                }).catchError((error) {
                  print('Failed to update appointment: $error');
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Randevunuz oluşturuldu.'),
                  backgroundColor: Color(0xFF504658),
                ));
              }
            }
          } else {
            // Belge yoksa, oluştur
            appointmentRef.set({
              'appointment_dates': [appointmentDate],
              // İstediğiniz ek alanları ekleyin
            }).then((value) {
              print('Appointment saved to Firestore with ID: $documentId');
            }).catchError((error) {
              print('Failed to save appointment: $error');
            });
          }
        });
      } else {
        print('User does not exist');
      }
    });
  }
}
