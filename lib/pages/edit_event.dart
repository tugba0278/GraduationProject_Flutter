import 'package:bitirme_projesi/model/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final Event event;
  const EditEvent(
      {Key? key,
      required this.firstDate,
      required this.lastDate,
      required this.event})
      : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  late DateTime _selectedDate;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.event.date;
    _titleController = TextEditingController(text: widget.event.title);
    _descController = TextEditingController(text: widget.event.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE8D6),
      appBar: AppBar(
        title: const Text("Hatırlatmayı Düzenle"),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFE8D6),
        titleTextStyle: const TextStyle(
            fontFamily: "Times New Roman",
            fontSize: 20,
            color: Color(0xFF3E3232),
            fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Color(0xFF503C3C), size: 35),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 100, right: 40, left: 40),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              InputDatePickerFormField(
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                initialDate: _selectedDate,
                onDateSubmitted: (date) {
                  print(date);
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _titleController,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'title',
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF503C3C), width: 2.0)),
                  labelStyle: TextStyle(
                      fontFamily: "Times New Roman",
                      fontSize: 16,
                      color: Color(0xFF3E3232)),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF3E3232), width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _descController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'description',
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF503C3C), width: 2.0)),
                  labelStyle: TextStyle(
                      fontFamily: "Times New Roman",
                      fontSize: 16,
                      color: Color(0xFF3E3232)),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF3E3232), width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, top: 80),
                  child: ElevatedButton(
                    onPressed: () {
                      _addEvent();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 210, 194, 180),
                        side: const BorderSide(
                            color: Color(0xFF706233), width: 2),
                        minimumSize: const Size(100, 50)),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Color.fromARGB(255, 90, 78, 41)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addEvent() async {
    final title = _titleController.text;
    final description = _descController.text;
    if (title.isEmpty) {
      print('title cannot be empty');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('title cannot be empty.'),
          backgroundColor: Color(0xFF504658),
        ),
      );
      return;
    }
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id)
        .update({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(_selectedDate),
    });
    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
