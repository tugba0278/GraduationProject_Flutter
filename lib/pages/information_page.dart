import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstTextController = TextEditingController();
  late DateTime _secondText = DateTime.now();
  final TextEditingController _secondTextController = TextEditingController();

  final TextEditingController _thirdTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _secondTextController.text = DateFormat("dd-MM-yyyy").format(_secondText);
  }

  @override
  void dispose() {
    _firstTextController.dispose();
    _secondTextController.dispose();
    _thirdTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        //overflow engellemek için
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/assets/background_image.png"),
                  alignment: Alignment.center,
                  fit: BoxFit.contain)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                20, 230, 20, 20), //her taraftan bırakılan mesafe ,)
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
                            fontSize: 27, //yazı boyutu

                            fontFamily: 'Arial',
                            fontWeight: FontWeight.bold //yazı tipi
                            ),
                      ),
                      const SizedBox(
                          height: 7), //text ve textformfield arası mesafe
                      TextFormField(
                        style: const TextStyle(
                          //E-mail textformfield wdiget özelleştirme
                          fontSize: 20, //yazı boyutu
                          fontStyle: FontStyle.italic, //yazı italik yapma
                          fontFamily: 'Arial', //yazı tipi

                          color: Colors.black, //input yazı rengi
                        ),
                        controller: _firstTextController,
                        keyboardType: TextInputType.text, //inputun tipi
                        decoration: const InputDecoration(
                            //input kutucuğu özelleştirme
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 50.0), //kenarlık rengi ve kalınlığı
                              borderRadius: BorderRadius.all(Radius
                                  .zero), // input kutucuğunun köşeli olmasını sağlar
                            ),
                            //kutucuğa tıklandığındaki görünüm
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC4646)),
                              borderRadius: BorderRadius.all(Radius.zero),
                            ),
                            filled: true, //kutucuk doldurulması için onay
                            fillColor: Colors
                                .white, // input kutucuğunun arka plan rengi
                            contentPadding: EdgeInsets.symmetric(
                              //input kutucuğunun yüksekliği
                              vertical: 5.0,
                            ),
                            hintText: '  Varsa Yazınız..'),
                        validator: (value) {
                          //input girilip girilmediğini kontrol eder
                          if (value == null || value.isEmpty) {
                            return 'Lütfen yanıtlayınız..'; //girilmediyse bu mesaj iletilir
                          }
                          return null; //e-mail geçerli
                        },
                      ),
                      const SizedBox(height: 35), //textboxlar arasındaki mesafe
                      const Text(
                        "En son ne zaman kan verdiniz?",
                        style: TextStyle(
                            //text widget özelleştirme
                            fontSize: 27, //yazı boyutu

                            fontFamily: 'Arial', //yazı
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                          height: 5), //text ve textformfield arası mesafe
                      TextFormField(
                        style: const TextStyle(
                          //textformfield widget özelleştirme
                          fontSize: 20, //yazı boyutu
                          fontStyle: FontStyle.italic, //yazı italik yapma
                          fontFamily: 'Arial', //yazı tipi
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate(context);
                        },
                        controller: _secondTextController,
                        decoration: const InputDecoration(
                            //input kutucuğu özelleştirme
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 50.0), //kenarlık rengi ve kalınlığı
                              borderRadius: BorderRadius.all(Radius
                                  .zero), //input kutucuğunun köşeli olması sağlanır
                            ),
                            //kutucuğa tıklandığındaki görünüm
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC4646)),
                              borderRadius: BorderRadius.all(Radius.zero),
                            ),
                            filled: true,
                            fillColor: Colors
                                .white, //input kutucuğunun arka plan rengi
                            contentPadding: EdgeInsets.symmetric(
                              //input kutucuğunun yüksekliği
                              vertical: 5.0,
                            ),
                            hintText: '  GG/AA/YY'),
                        validator: (value) {
                          //input girilip girilmediğini kontrol eder
                          if (value == null || value.isEmpty) {
                            return 'Lütfen yanıtlayınız..'; //girilmediyse bu mesaj iletilir
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 35), //textboxlar arasındaki mesafe
                      const Text(
                        "Kilonuzu giriniz",
                        style: TextStyle(
                          //text widget özelleştirme
                          fontSize: 27, //yazı boyutu
                          fontWeight: FontWeight.bold, //yazı kalın yapma
                          fontFamily: 'Arial', //yazı tipi
                        ),
                      ),
                      const SizedBox(
                          height: 5), //text ve textformfield arası mesafe
                      TextFormField(
                        style: const TextStyle(
                          //textformfield widget özelleştirme
                          fontSize: 20, //yazı boyutu
                          fontStyle: FontStyle.italic, //yazı italik yapma
                          fontFamily: 'Arial', //yazı tipi
                        ),
                        controller: _thirdTextController,
                        decoration: const InputDecoration(
                          //input kutucuğu özelleştirme
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black,
                                width: 50.0), //kenarlık rengi ve kalınlığı
                            borderRadius: BorderRadius.all(Radius
                                .zero), //input kutucuğunun köşeli olması sağlanır
                          ),
                          //kutucuğa tıklandığındaki görünüm
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCC4646)),
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                          filled: true,
                          fillColor:
                              Colors.white, //input kutucuğunun arka plan rengi
                          contentPadding: EdgeInsets.symmetric(
                            //input kutucuğunun yüksekliği
                            vertical: 5.0,
                          ),
                          hintText: '  50 (kg)',
                        ),
                        validator: (value) {
                          //input girilip girilmediğini kontrol eder
                          if (value == null || value.isEmpty) {
                            return 'Lütfen yanıtlayınız..'; //girilmediyse bu mesaj iletilir
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end, // yatayda merkeze hizalama
                    children: [
                      ElevatedButton(
                        //ileri butonu
                        onPressed: () async {
                          // if (_formKey.currentState!.validate()) {
                          //   final first = _firstText.text;
                          //   final second = _secondText.text;
                          //   final third = _thirdText.text;

                          //   try {
                          //     await FirebaseAuth.instance
                          //         .signInWithEmailAndPassword(
                          //       email: email,
                          //       password: password,
                          //     );
                          //     // ignore: use_build_context_synchronously
                          //     Navigator.of(context).pushNamedAndRemoveUntil(
                          //         homePageRoute, (route) => false);
                          //   } catch (e) {
                          //     print(e.toString());
                          //     showUserNotFoundDialog(
                          //       context,
                          //       "Email veya şifreniz yanlıştır",
                          //     );
                          //   }
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                            //butonu özelleştirme
                            backgroundColor: const Color(
                                0xFFCC4646), //ileri butonunun arka plan rengi
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), //ileri butonunun köşe ovalliği
                            ),
                            padding: const EdgeInsets.symmetric(
                                //butonun yazı ile arasındaki mesafe
                                vertical: 5, //dikeyde
                                horizontal: 30) //yatayda
                            ),
                        child: const Text(
                          'İleri',
                          style: TextStyle(
                              //text için özelleştirme
                              fontSize: 20, //yazı boyutu
                              fontFamily: 'Arial', //yazı tipi
                              fontWeight: FontWeight.bold, //yazı kalınlaştırma
                              fontStyle: FontStyle.italic, //yazı italik yapma
                              color: Colors.white //yazı rengi
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
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _secondText,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _secondText) {
      setState(() {
        _secondText = picked;
        _secondTextController.text =
            DateFormat("dd-MM-yyyy").format(_secondText);
      });
    }
  }
}
