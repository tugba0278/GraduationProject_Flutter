import 'package:bitirme_projesi/pages/event2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<Event>> events = {};
  final TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;

  String? _userName;
  late List<Event> eventsForDay = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _initializeEventsForDay();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Etkinlikleri önceden yüklemek için kullanılan `_fetchEventsForDay` fonksiyonunu çağırın
    return events[day] ?? [];
  }

  Future<List<Event>> _fetchEventsForDay(DateTime day) async {
    try {
      // Firestore'dan belirli bir tarihteki etkinlikleri çekmek için sorgu
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(_userName) // Belirli bir günün belge ID'si
          .get();

      if (docSnapshot.exists) {
        // Belge varsa, etkinlikleri al
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> eventData = data[day.toString()] ?? [];
        return eventData.map((event) => Event(event['eventName'])).toList();
      }
    } catch (error) {
      print('Failed to fetch events for day: $error');
    }
    return []; // Hata durumunda boş bir liste döndür
  }

  void _initializeEventsForDay() async {
    eventsForDay = await _fetchEventsForDay(_selectedDay!);
    print(eventsForDay);
  }

  // Kullanıcı adını Firestore'dan yükle
  void loadUserName() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

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
          padding: EdgeInsets.only(left: 30, right: 30),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text("Etkinlik Adı"),
                  content: Padding(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      controller: _eventController,
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          events.addAll({
                            _selectedDay!: [Event(_eventController.text)]
                          });
                          print(events);
                          print(events[_selectedDay]);
                          List<String> eventNames = events[_selectedDay]!
                              .map((event) => event.title)
                              .toList();
                          String eventNameString = eventNames.join(
                              ', '); // Veya başka bir ayraç kullanabilirsiniz

                          print(
                              eventNameString); // Event isimlerini içeren dizeyi yazdır
                          if (_selectedDay != null &&
                              _eventController.text.isNotEmpty) {
                            _saveAppointmentToDatabase(
                                _selectedDay!, _eventController.text);
                            setState(() {
                              _eventController.clear();
                            });
                          } else {
                            // Kullanıcıya geçerli bir tarih ve etkinlik adı girmesi gerektiğini bildir
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  'Lütfen geçerli bir tarih ve etkinlik adı girin.'),
                              backgroundColor: Color(0xFF504658),
                            ));
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text("Oluştur"))
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDay =
                null; // Boş bir yere tıklandığında seçilen tarihi sil
          });
        },
        child: Container(
          //height: 10000,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TableCalendar(
                calendarStyle: const CalendarStyle(
                  cellMargin: EdgeInsets.all(8.0),
                  defaultTextStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                eventLoader: _getEventsForDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    // Eğer seçilen gün zaten varsa, işlemi gerçekleştirme
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _selectedEvents.value = _getEventsForDay(selectedDay);
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
              Expanded(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (BuildContext context, dynamic value, _) {
                    return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              onTap: () => print(""),
                              title: Text('${value[index].title}'),
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveAppointmentToDatabase(DateTime appointmentDate, String eventName) {
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
            Map<String, dynamic> data =
                docSnapshot.data() as Map<String, dynamic>? ?? {};

            // Seçilen gün için etkinlik listesini al
            List<Map<String, dynamic>> eventsForSelectedDate =
                List<Map<String, dynamic>>.from(
                    data[appointmentDate.toString()] ?? []);

            // Seçilen gün için yeni etkinliği ekle
            eventsForSelectedDate.add({'eventName': eventName});

            // Verileri güncelle
            appointmentRef.update({
              // Etkinlik listesini güncelle
              appointmentDate.toString(): FieldValue.arrayUnion([
                {'eventName': eventName}
              ]),
            }).then((value) {
              print('Appointment updated in Firestore with ID: $documentId');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Randevunuz oluşturuldu.'),
                backgroundColor: Color(0xFF504658),
              ));
            }).catchError((error) {
              print('Failed to update appointment: $error');
            });
          } else {
            // Belge yoksa, oluştur
            appointmentRef.set({
              // Yeni etkinlik map'i oluştur
              appointmentDate.toString(): [
                {'eventName': eventName}
              ],
              // Randevu tarihlerini güncelle

              // İstediğiniz ek alanları ekleyin
            }).then((value) {
              print('Appointment saved to Firestore with ID: $documentId');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Randevunuz oluşturuldu.'),
                backgroundColor: Color(0xFF504658),
              ));
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
