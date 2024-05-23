import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
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
          padding: EdgeInsets.only(left: 80),
          child: Text(
            'Randevu',
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
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: TableCalendar(
                  calendarStyle: CalendarStyle(
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
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
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
                    return !day
                        .isBefore(DateTime.now().subtract(Duration(days: 1)));
                  },
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30, bottom: 120),
                  child: FloatingActionButton(
                    onPressed: () {
                      if (_selectedDay != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Randevu Tarihi'),
                              content: Text(
                                'Seçilen tarih: ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    _saveAppointmentToDatabase(_selectedDay!);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Kaydet'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('İptal'),
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
  }
}
