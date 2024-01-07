import 'package:bitirme_projesi/routes.dart';
import 'package:bitirme_projesi/utilities/dialogs/user_not_found_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  Widget build(BuildContext context) {
    const buttonTextStyle = TextStyle(
      fontSize: 20,
      fontFamily: 'Calibri',
      fontWeight: FontWeight.w500,
      //fontStyle: FontStyle.italic,
      color: Colors.white,
    );
    return Scaffold(
      body: SingleChildScrollView(
        //overflow engellemek için
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/assets/background_image.png"),
                  alignment: Alignment.center,
                  fit: BoxFit.contain)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  20, 280, 20, 20), //her taraftan bırakılan mesafe ,)
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      //e-mail için column
                      children: [
                        const Text(
                          //E-mail yazısı
                          "E-MAİL",
                          style: TextStyle(
                            //E-mail text widget özelleştirme
                            fontSize: 30, //yazı boyutu
                            fontStyle: FontStyle.italic, //yazıyı italik yapmak
                            fontFamily: 'Courier', //yazı tipi
                          ),
                        ),
                        const SizedBox(
                            height: 5), //text ve textformfield arası mesafe
                        TextFormField(
                          style: const TextStyle(
                            //E-mail textformfield wdiget özelleştirme
                            fontSize: 20, //yazı boyutu
                            fontStyle: FontStyle.italic, //yazı italik yapma
                            fontFamily: 'Courier', //yazı tipi
                            fontWeight:
                                FontWeight.bold, //input yazısını kalınlaştırmak
                            color: Colors.black, //input yazı rengi
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
                          ),
                          validator: (value) {
                            //e-mail input girilip girilmediğini kontrol eder
                            if (value == null || value.isEmpty) {
                              return 'Lütfen e-posta adresinizi girin'; //e-mail girilmediyse bu mesaj iletilir
                            } else if (!value.contains('@')) {
                              return 'Geçerli bir e-posta adresi girin'; //@ işaretini içermezse bu mesaj iletilir
                            }
                            return null; //e-mail geçerli
                          },
                        ),
                        const SizedBox(
                            height: 35), //textboxlar arasındaki mesafe
                        const Text(
                          //Parola yazısı
                          "PAROLA",
                          style: TextStyle(
                            //Parola text widget özelleştirme
                            fontSize: 30, //yazı boyutu
                            fontStyle: FontStyle.italic, //yazı italik yapma
                            fontFamily: 'Courier', //yazı tipi
                          ),
                        ),
                        const SizedBox(
                            height: 5), //text ve textformfield arası mesafe
                        TextFormField(
                          style: const TextStyle(
                            //textformfield widget özelleştirme
                            fontSize: 20, //yazı boyutu
                            fontStyle: FontStyle.italic, //yazı italik yapma
                            fontFamily: 'Courier', //yazı tipi
                            fontWeight: FontWeight.bold, //yazı kalınlaştırma
                          ),
                          controller: _passwordController,
                          obscureText: true, //parola girişinin içeriği gizlenir
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
                          ),
                          validator: (value) {
                            //parola input girilip girilmediğini kontrol eder
                            if (value == null || value.isEmpty) {
                              return 'Lütfen parolanızı girin'; //parola girilmediyse bu mesaj iletilir
                            }
                            return null; //parola geçerli
                          },
                        ),
                      ],
                    ),

                    const SizedBox(
                        height:
                            90), // parola kutucuğu ve giriş yap butonu arasındaki mesafe

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
                                showUserNotFoundDialog(
                                  context,
                                  "Email veya şifreniz yanlıştır",
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              //butonu özelleştirme
                              backgroundColor: const Color(
                                  0xFFCC4646), //giriş yap butonunun arka plan rengi
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), //giriş yap butonunun köşe ovalliği
                              ),
                              padding: const EdgeInsets.symmetric(
                                  //butonun yazı ile arasındaki mesafe
                                  vertical: 5, //dikeyde
                                  horizontal: 30) //yatayda
                              ),
                          child: const Text(
                            'Giriş Yap',
                            style: buttonTextStyle,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .end, //textbuttonu yatayda sona taşıma
                      children: [
                        TextButton(
                          onPressed: () {
                            // Şifremi Unuttum butonu için işlemler
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal:
                                    10), //buttonun yazı ile arasındaki mesafe
                          ),
                          child: const Text(
                            //text için özelleştirme
                            'Şifremi Unuttum',
                            style: TextStyle(
                              color: Colors.black, //yazı rengi
                              fontSize: 20, //yazı boyutu
                              fontFamily: 'Courier', //yazı tipi
                              fontWeight: FontWeight.bold, //yazı kalınlaştırma
                            ),
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
                        ElevatedButton(
                          onPressed: () async {
                            const String urlString =
                                'https://giris.turkiye.gov.tr/Giris/gir';
                            try {
                              await launch(urlString);
                            } catch (e) {
                              if (kDebugMode) {
                                print('Error launching URL: $e');
                              }
                            }

                            // Kullanıcı harici sitede giriş yaptıktan sonra çalışacak kodu buraya ekleyebilirsiniz
                            // Örneğin, belirli bir olay gerçekleştikten sonra geri gitmek istiyorsanız:
                            // Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCC4646),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 30,
                            ),
                          ),
                          child: const Text(
                            'e-Devlet ile Giriş',
                            style: buttonTextStyle,
                          ),
                        ),
                        const SizedBox(height: 15), // Buttonlar arası mesafe
                        ElevatedButton(
                          // Kaydol button
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              registerPageRoute,
                              (_) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCC4646),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 50,
                            ),
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
