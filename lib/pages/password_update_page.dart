import 'package:bitirme_projesi/routes.dart';
import 'package:bitirme_projesi/utilities/dialogs/password_not_updated_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordUpdatePage extends StatefulWidget {
  const PasswordUpdatePage({super.key});

  @override
  State<PasswordUpdatePage> createState() => _PasswordUpdatePageState();
}

class _PasswordUpdatePageState extends State<PasswordUpdatePage> {
  final _formKey = GlobalKey<
      FormState>(); // formun durumunu yöneten bir anahtar (key) oluşturur(erişim sağlama,kontrol etme..)
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _repPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _showEmailWarning = false;
  bool _showRepPasswordWarning = false;
  bool _showPasswordWarning = false;

  @override
  Widget build(BuildContext context) {
    const buttonTextStyle = TextStyle(
      fontSize: 20,
      fontFamily: 'Times New Roman',
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context,
                loginPageRoute,
                (route) =>
                    false); // Geri tuşuna basıldığında önceki sayfaya dön
          },
          iconSize: 50,
          color: const Color(0xFFCC4646),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Boş bir alana tıklandığında uyarıları kaldır
          FocusScope.of(context).unfocus();
          setState(() {
            _showEmailWarning = false;
            _showRepPasswordWarning = false;
            _showPasswordWarning = false;
          });
        },
        child: SingleChildScrollView(
          //overflow engellemek için
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("lib/assets/background_image.png"),
              alignment: Alignment.center,
              fit: BoxFit.contain,
            )),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  50, 0, 50, 20), //her taraftan bırakılan mesafe ,)
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Email",
                            style: TextStyle(
                              fontSize: 27,
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left),
                        const SizedBox(height: 5),
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Times New Roman',
                          ),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0),
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
                                vertical: 5.0, horizontal: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _showEmailWarning = true;
                                _repPasswordController.clear();
                                _passwordController.clear();
                                _emailController.clear();
                              });
                            }
                            return null;
                          },
                        ),
                        if (_showEmailWarning)
                          const Text(
                            'Lütfen email girin',
                            style: TextStyle(
                              color: Color(0xFFCC4646),
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 35),
                        const Text("Mevcut Şifre",
                            style: TextStyle(
                              fontSize: 27,
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
                          keyboardType: TextInputType.visiblePassword,
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
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _showPasswordWarning = true;
                                _repPasswordController.clear();
                                _passwordController.clear();
                                _emailController.clear();
                              });
                            }
                            return null;
                          },
                        ),
                        if (_showPasswordWarning)
                          const Text(
                            'Lütfen parola girin',
                            style: TextStyle(
                              color: Color(0xFFCC4646),
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(
                            height: 35), //textboxlar arasındaki mesafe
                        const Text(
                            //Parola yazısı
                            "Yeni Şifre",
                            style: TextStyle(
                              fontSize: 27, //yazı boyutu
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
                          controller: _repPasswordController,
                          obscureText: true, //parola girişinin içeriği gizlenir
                          keyboardType: TextInputType.visiblePassword,
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
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _showRepPasswordWarning = true;
                                _repPasswordController.clear();
                                _passwordController.clear();
                                _emailController.clear();
                              });
                            }
                            return null;
                          },
                        ),
                        if (_showRepPasswordWarning)
                          const Text(
                            'Lütfen parola tekrarını girin',
                            style: TextStyle(
                              color: Color(0xFFCC4646),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // yatayda merkeze hizalama
                      children: [
                        const SizedBox(height: 100),
                        ElevatedButton(
                          ///güncelle butonu
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final email = _emailController.text;
                              final currentPassword = _passwordController.text;
                              final newPassword = _repPasswordController.text;

                              _changePassword(
                                  context, email, currentPassword, newPassword);
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
                            'Güncelle',
                            style: buttonTextStyle,
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
}

void _changePassword(BuildContext context, String email, String currentPassword,
    String newPassword) async {
  try {
    final userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: currentPassword,
    );

    final user = userCredential.user;

    if (user != null) {
      await user.updatePassword(newPassword);

      Navigator.of(context)
          .pushNamedAndRemoveUntil(loginPageRoute, (route) => false);
    } else {
      showNotUpdateDialog(context, "Şifre güncellenirken hata oluştu.");
    }
  } catch (error) {
    showNotUpdateDialog(
        context, "Şifre güncellenirken hata oluştu.Kullanıcı bulunamadı.");
  }
}
