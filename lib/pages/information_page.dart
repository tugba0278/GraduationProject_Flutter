import 'package:bitirme_projesi/routes.dart';
import 'package:bitirme_projesi/services/cloud_database/firebase_cloud_user_crud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _secondTextController = TextEditingController();
  final TextEditingController _thirdTextController = TextEditingController();

  final FirebaseCloudStorage _firestore = FirebaseCloudStorage();

  @override
  void initState() {
    super.initState();
    _secondTextController.text =
        DateFormat("dd-MM-yyyy").format(DateTime.now());
  }

  @override
  void dispose() {
    _secondTextController.dispose();
    _thirdTextController.dispose();
    super.dispose();
  }

  bool _showDiseaseInfoWarning = false;
  bool _showBloodDonationWarning = false;
  bool _showKiloWarning = false;

  String? _selectedDiseaseInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          // Boş bir alana tıklandığında uyarıları kaldır
          FocusScope.of(context).unfocus();
          setState(() {
            _showDiseaseInfoWarning = false;
            _showBloodDonationWarning = false;
            _showKiloWarning = false;
          });
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/assets/bg5.jpg"),
              alignment: Alignment.center,
              fit: BoxFit.contain,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 180, 40, 60),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Daha önce hastalık geçirdiniz mi?",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 7),
                        DropdownButtonFormField<String>(
                          value: _selectedDiseaseInfo,
                          items: ["Evet", "Hayır"].map((String? value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value ?? ""),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedDiseaseInfo = value;
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 50.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC4646)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(255, 255, 255, 0.7),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _showDiseaseInfoWarning = true;
                                _selectedDiseaseInfo = null;
                              });
                            }
                            return null;
                          },
                        ),
                        if (_showDiseaseInfoWarning)
                          const Text(
                            'Lütfen seçiniz..',
                            style: TextStyle(
                              color: Color(0xFFCC4646),
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 35),
                        const Text(
                          "En son ne zaman kan verdiniz?",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Times New Roman',
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate(context);
                          },
                          controller: _secondTextController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 50.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC4646)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(255, 255, 255, 0.7),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10,
                            ),
                            hintText: '  GG/AA/YY',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _showBloodDonationWarning = true;
                              });
                            }
                            return null;
                          },
                        ),
                        if (_showBloodDonationWarning)
                          const Text(
                            'Lütfen yanıtlayınız..',
                            style: TextStyle(
                              color: Color(0xFFCC4646),
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 35),
                        const Text(
                          "Kilonuzu giriniz",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Times New Roman',
                          ),
                          controller: _thirdTextController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 50.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC4646)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10,
                            ),
                            hintText: '  50 (kg)',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _showKiloWarning = true;
                              });
                            }
                            return null;
                          },
                        ),
                        if (_showKiloWarning)
                          const Text(
                            'Lütfen yanıtlayınız..',
                            style: TextStyle(
                              color: Color(0xFFCC4646),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _updateField,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCC4646),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            minimumSize: const Size(120, 45),
                          ),
                          child: const Text(
                            'İleri',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateField() async {
    if (_formKey.currentState!.validate()) {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      await _firestore.updateDiseaseInfo(
          documentId: userId, diseaseInfo: _selectedDiseaseInfo!);

      await _firestore.updateLastBloodDonationDate(
          documentId: userId, lastBloodDonation: _secondTextController.text);

      await _firestore.updateKilo(
          documentId: userId, kilo: _thirdTextController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veriler başarıyla kaydedildi.'),
          backgroundColor: Color(0xFF504658),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
          context, homePageRoute, (route) => false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _secondTextController.text = DateFormat("dd-MM-yyyy").format(picked);
      });
    }
  }
}
