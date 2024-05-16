import 'package:bitirme_projesi/routes.dart';
import 'package:bitirme_projesi/utilities/dialogs/user_not_found_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final _formKey = GlobalKey<
      FormState>(); // formun durumunu yöneten bir anahtar (key) oluşturur(erişim sağlama,kontrol etme..)
  final TextEditingController _passwordController =
      TextEditingController(); //passwordun girileceği text metnin kontrolünü sağlar
  final TextEditingController _emailController =
      TextEditingController(); //e-mailin girileceği text metnin kontrolünü sağlar

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _showEmailWarning = false;
  bool _showPasswordWarning = false;

  @override
  Widget build(BuildContext context) {
    const buttonTextStyle = TextStyle(
      fontSize: 20,
      fontFamily: 'Times New Roman',
      fontWeight: FontWeight.w500,
      color: Color(0xFFCC4646),
    );
    const buttonTextStyle2 = TextStyle(
      fontSize: 20,
      fontFamily: 'Times New Roman',
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          // Boş bir alana tıklandığında uyarıları kaldır
          FocusScope.of(context).unfocus();
          setState(() {
            _showEmailWarning = false;
            _showPasswordWarning = false;
          });
        },
        child: SingleChildScrollView(
          //overflow engellemek için
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("lib/assets/background_image.png"),
              alignment: Alignment.center,
              fit: BoxFit.contain,
            )),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  50, 260, 50, 20), //her taraftan bırakılan mesafe ,)
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //e-mail için column
                      children: [
                        const Text("Eposta",
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left),
                        const SizedBox(
                            height: 5), //text ve textformfield arası mesafe
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Times New Roman',
                          ),
                          controller: _emailController,
                          keyboardType:
                              TextInputType.emailAddress, //inputun tipi
                          decoration: const InputDecoration(
                            //input kutucuğu özelleştirme
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 50.0), //kenarlık rengi ve kalınlığı
                              borderRadius: BorderRadius.all(Radius.circular(
                                  10)), // input kutucuğunun köşeli olmasını sağlar
                            ),
                            //kutucuğa tıklandığındaki görünüm
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC4646)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true, //kutucuk doldurulması için onay
                            fillColor: Color.fromRGBO(255, 255, 255,
                                0.7), // input kutucuğunun arka plan rengi
                            contentPadding: EdgeInsets.symmetric(
                              //input kutucuğunun yüksekliği
                              vertical: 5.0,
                              horizontal: 10,
                            ),
                          ),
                          validator: (value) {
                            //tam ad input girilip girilmediğini kontrol eder
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _showEmailWarning = true;
                              });
                            } else if (!value.contains('@')) {
                              return 'Geçerli bir e-posta adresi girin'; //@ işaretini içermezse bu mesaj iletilir
                            }
                            return null;
                          },
                        ),
                        if (_showEmailWarning)
                          const Text(
                            'Lütfen eposta adresi girin',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(
                            height: 35), //textboxlar arasındaki mesafe
                        const Text(
                            //Parola yazısı
                            "Parola",
                            style: TextStyle(
                              fontSize: 30, //yazı boyutu
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left),
                        const SizedBox(
                            height: 5), //text ve textformfield arası mesafe
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Times New Roman',
                          ),
                          controller: _passwordController,
                          obscureText: true, //parola girişinin içeriği gizlenir
                          decoration: const InputDecoration(
                            //input kutucuğu özelleştirme
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 50.0), //kenarlık rengi ve kalınlığı
                              borderRadius: BorderRadius.all(Radius.circular(
                                  10)), //input kutucuğunun köşeli olması sağlanır
                            ),
                            //kutucuğa tıklandığındaki görünüm
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC4646)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(255, 255, 255,
                                0.7), //input kutucuğunun arka plan rengi
                            contentPadding: EdgeInsets.symmetric(
                              //input kutucuğunun yüksekliği
                              vertical: 5.0,
                              horizontal: 10,
                            ),
                          ),
                          validator: (value) {
                            //tam ad input girilip girilmediğini kontrol eder
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _showPasswordWarning = true;
                              });
                            }
                            return null;
                          },
                        ),
                        if (_showPasswordWarning)
                          const Text(
                            'Lütfen parola girin',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        TextButton(
                          onPressed: () {
                            // Şifremi Unuttum butonu için işlemler
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal:
                                    5), //buttonun yazı ile arasındaki mesafe
                          ),
                          child: const Text(
                            //text için özelleştirme
                            'Şifremi Unuttum',
                            style: TextStyle(
                              color: Colors.black, //yazı rengi
                              fontSize: 15, //yazı boyutu
                              fontFamily: 'calibri', //yazı tipi
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // yatayda merkeze hizalama
                      children: [
                        ElevatedButton(
                          //giriş yap butonu
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    informationPageRoute, (route) => false);
                              } catch (e) {
                                print(e.toString());
                                // Eğer Firebase kullanıcısını bulamazsa uyarıyı göster
                                showUserNotFoundDialog(
                                  context,
                                  "Email veya şifreniz yanlıştır",
                                );
                                setState(() {
                                  _emailController.clear();
                                  _passwordController.clear();
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            //butonu özelleştirme
                            backgroundColor: const Color(
                                0xFFCC4646), //giriş yap butonunun arka plan rengi
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), //giriş yap butonunun köşe ovalliği
                            ),
                            minimumSize:
                                const Size(180, 50), // Sabit boyut tanımı
                          ),

                          child: const Text(
                            'Giriş Yap',
                            style: buttonTextStyle2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                        //butonu ile textbutton arası mesafe
                        height: 20),
                    Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // yatayda merkeze hizalama
                      children: [
                        const SizedBox(height: 10), // Buttonlar arası mesafe
                        ElevatedButton(
                          // Kaydol button
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              registerPageRoute,
                              (_) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                color: Color(0xFFCC4646),
                              ),
                            ),
                            minimumSize: const Size(180, 50),
                          ),
                          child: const Text('Kaydol', style: buttonTextStyle),
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
}
