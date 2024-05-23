import 'package:bitirme_projesi/routes.dart';
import 'package:bitirme_projesi/services/cloud_database/firebase_cloud_user_crud.dart';
import 'package:bitirme_projesi/utilities/dialogs/email_already_in_use_dialog.dart';
import 'package:bitirme_projesi/utilities/dialogs/user_created_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitirme_projesi/user_auth/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});
  @override
  State<RegisterUser> createState() => _MyFormState();
}

class _MyFormState extends State<RegisterUser> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseCloudStorage _firestore = FirebaseCloudStorage();

  final _formKey =
      GlobalKey<FormState>(); //doğrulama işlemleri için key oluşturur
  final TextEditingController _fullNameController =
      TextEditingController(); //adın girileceği text metnin kontrolünü sağlar
  final TextEditingController _phoneNumberController =
      TextEditingController(); //numaranın girileceği text metnin kontrolünü sağlar
  final TextEditingController _passwordController =
      TextEditingController(); //passwordun girileceği text metnin kontrolünü sağlar
  final TextEditingController _emailController =
      TextEditingController(); //e-mailin girileceği text metnin kontrolünü sağlar
  final TextEditingController _bloodTypeController =
      TextEditingController(); //kan grubu girileceği textin kontrolünü sağlar

  late DateTime _birthDate = DateTime.now();
  final TextEditingController _birthDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _birthDateController.text = DateFormat("dd-MM-yyyy").format(_birthDate);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bloodTypeController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  bool _showNameWarning = false;
  bool _showBirthDateWarning = false;
  bool _showBloodWarning = false;
  bool _showPhoneNumberWarning = false;
  bool _showEmailWarning = false;
  bool _showPasswordWarning = false;

  @override
  Widget build(BuildContext context) {
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
            _showNameWarning = false;
            _showBirthDateWarning = false;
            _showBloodWarning = false;
            _showPhoneNumberWarning = false;
            _showEmailWarning = false;
            _showPasswordWarning = false;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/assets/background_image.png"),
                  alignment: Alignment.center,
                  fit: BoxFit.contain)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  50, 10, 50, 20), //her taraftan bırakılan mesafe ,)
              child: Form(
                //form widgeti
                key: _formKey, //kontrolü sağlamak için anahtar
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, //dikeyde merkeze hizalama
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, //yatayda merkeze hizalama
                      children: [
                        const Text(
                          "Ad Soyad",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Times New Roman',
                          ),
                          controller:
                              _fullNameController, //tam ad içeriği kontrolü
                          decoration: const InputDecoration(
                            //input kutucuğu özelleştirme
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  10)), //kutucuk kenarları ovallik 0
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC4646)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(
                                255, 255, 255, 0.7), //kutucuk rengi
                            contentPadding: EdgeInsets.symmetric(
                              //yazı ve kutucuk arasındaki dikey mesafe
                              vertical: 3.0,
                              horizontal: 10,
                            ),
                          ),
                          validator: (value) {
                            //tam ad input girilip girilmediğini kontrol eder
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _showNameWarning = true;
                                _fullNameController.clear();
                                _birthDateController.clear();
                                _bloodTypeController.clear();
                                _phoneNumberController.clear();
                                _emailController.clear();
                                _passwordController.clear();
                              });
                            }
                            return null;
                          },
                        ),
                        if (_showNameWarning)
                          const Text(
                            'Lütfen ad soyad girin',
                            style: TextStyle(
                              color: Color(0xFFCC4646),
                              fontSize: 12,
                            ),
                          ),

                        const SizedBox(height: 10),
                        const Text(
                          "Doğum Tarihi ",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),

                        TextFormField(
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Times New Roman',
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate(context);
                          },
                          controller: _birthDateController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC4646)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(255, 255, 255, 0.7),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0,
                              horizontal: 10,
                            ),
                            hintText: 'GG-AA-YY',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _showBirthDateWarning = true;
                                _fullNameController.clear();
                                _birthDateController.clear();
                                _bloodTypeController.clear();
                                _phoneNumberController.clear();
                                _emailController.clear();
                                _passwordController.clear();
                              });
                            }
                            return null;
                          },
                        ),
                        if (_showBirthDateWarning)
                          const Text(
                            'Lütfen doğum tarihi girin',
                            style: TextStyle(
                              color: Color(0xFFCC4646),
                              fontSize: 12,
                            ),
                          ),

                        const SizedBox(height: 10),
                        const Text(
                          "Kan Grubu",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Times New Roman',
                          ),
                          controller: _bloodTypeController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC4646)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(255, 255, 255, 0.7),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0,
                              horizontal: 10,
                            ),
                            hintText: 'Örneğin: A Rh+',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _showBloodWarning = true;
                                _fullNameController.clear();
                                _birthDateController.clear();
                                _bloodTypeController.clear();
                                _phoneNumberController.clear();
                                _emailController.clear();
                                _passwordController.clear();
                              });
                            }
                            return null;
                          },
                        ),
                        if (_showBloodWarning)
                          const Text(
                            'Lütfen kan grubu girin',
                            style: TextStyle(
                              color: Color(0xFFCC4646),
                              fontSize: 12,
                            ),
                          ),

                        const SizedBox(height: 10),
                        const Text(
                          "Telefon Numarası",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),

                        TextFormField(
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Times New Roman',
                          ),
                          controller:
                              _phoneNumberController, //numara içeriği kontrolü
                          keyboardType: TextInputType.phone, //input tipi
                          decoration: const InputDecoration(
                            //input kutucuğu özelleştirme
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  10)), //input kutucuğu ovalliği 0
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC4646)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(
                                255, 255, 255, 0.7), //kutucuk rengi
                            contentPadding: EdgeInsets.symmetric(
                              //input ve kutucuk arasındaki mesafe
                              vertical: 3.0,
                              horizontal: 10,
                            ),
                            hintText: '(5--)',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _showPhoneNumberWarning = true;
                                _fullNameController.clear();
                                _birthDateController.clear();
                                _bloodTypeController.clear();
                                _phoneNumberController.clear();
                                _emailController.clear();
                                _passwordController.clear();
                              });
                            }
                            return null;
                          },
                        ),
                        if (_showPhoneNumberWarning)
                          const Text(
                            'Lütfen numara girin',
                            style: TextStyle(
                              color: Color(0xFFCC4646),
                              fontSize: 12,
                            ),
                          ),

                        const SizedBox(
                            height:
                                10), //2. kutucuk ve 3. text arasındaki mesafe
                        const Text(
                          "Eposta",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),

                        TextFormField(
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Times New Roman',
                            ),
                            controller:
                                _emailController, //e-mail içeriği kontrolü
                            keyboardType:
                                TextInputType.emailAddress, //input tipi
                            decoration: const InputDecoration(
                              //input kutucuğu özelleştirme
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    10)), //kutucuk kenarları ovalliği 0
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFCC4646)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(
                                  255, 255, 255, 0.7), //kutucuk rengi
                              contentPadding: EdgeInsets.symmetric(
                                  //input ve kutucuk arasındaki dikey mesafe
                                  vertical: 3.0,
                                  horizontal: 10),
                              hintText: 'name@gmail.com',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  _showEmailWarning = true;
                                  _fullNameController.clear();
                                  _birthDateController.clear();
                                  _bloodTypeController.clear();
                                  _phoneNumberController.clear();
                                  _emailController.clear();
                                  _passwordController.clear();
                                });
                              } else if (!value.contains('@')) {
                                return 'Geçerli bir e-posta adresi girin'; //@ işaretini içermezse bu mesaj iletilir
                              }
                              return null;
                            }),
                        if (_showEmailWarning)
                          const Text(
                            'Lütfen e-mail girin',
                            style: TextStyle(
                              color: Color(0xFFCC4646),
                              fontSize: 12,
                            ),
                          ),

                        const SizedBox(
                            height:
                                10), //3. kutucuk ve 4. text arasındaki mesafe
                        const Text(
                          "Parola",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),

                        TextFormField(
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Times New Roman',
                          ),
                          controller:
                              _passwordController, //parola içeriği kontrolü
                          obscureText: true, //parola içeriği gizleme(*)
                          decoration: const InputDecoration(
                            //input kutucuğu özelleştirme
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  10)), //kutucuk kenarları ovalliği 0
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCC4646)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(
                                255, 255, 255, 0.7), //kutucuk rengi
                            contentPadding: EdgeInsets.symmetric(
                              //text ve kutucuk arasındaki dikey mesafe
                              vertical: 3.0,
                              horizontal: 10,
                            ),
                            hintText: '***',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _showPasswordWarning = true;
                                _fullNameController.clear();
                                _birthDateController.clear();
                                _bloodTypeController.clear();
                                _phoneNumberController.clear();
                                _emailController.clear();
                                _passwordController.clear();
                              });
                            }
                            return null;
                          },
                        ),
                        if (_showPasswordWarning)
                          const Text(
                            'Lütfen şifre girin',
                            style: TextStyle(
                              color: Color(0xFFCC4646),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(
                        height: 30), //son kutucuk ve buton arasındaki mesafe

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFCC4646), //kaydol butonu rengi
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), //kaydol butonu kenarlarının ovalliği
                          ),
                          minimumSize: const Size(180, 50),
                        ),
                        child: const Text(
                          'Kaydol',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.w500,
                              color: Colors.white //yazı rengi
                              ),
                          textAlign: TextAlign.left,
                        ),
                      ),
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

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        User? user = await _auth.signUpWithEmailAndPassword(email, password);

        if (user != null) {
          final ownerUserId = FirebaseAuth.instance.currentUser!.uid;

          await _firestore.createNewUser(
            ownerUserId: ownerUserId,
            documentId:
                ownerUserId, // Belge ID'si olarak kullanıcı ID'sini ayarlayın
            name: _fullNameController.text,
            phoneNumber: _phoneNumberController.text,
            birthDate: _birthDateController.text,
            blood: _bloodTypeController.text,
          );
          userCreatedDialog(context, "user is succesfully created");
          print("user is succesfully created");
          print(user.toString());
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
              context, loginPageRoute, (route) => false);
          setState(() {
            _emailController.clear();
            _passwordController.clear();
            _fullNameController.clear();
            _phoneNumberController.clear();
            _bloodTypeController.clear();
            _birthDateController.clear();
          });
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          // Check the error code to determine the specific error
          if (e.code == 'email-already-in-use') {
            // Handle the case where the email address is already in use
            print('The email address is already in use by another account.');
            // ignore: use_build_context_synchronously
            showEmailAlreadyInUseDialog(context,
                'The email address is already in use by another account.');
            // You might want to inform the user or take appropriate action.
          } else {
            // Handle other FirebaseAuthException errors
            print('Firebase Authentication Error: ${e.message}');
          }
          setState(() {
            _emailController.clear();
            _passwordController.clear();
            _fullNameController.clear();
            _phoneNumberController.clear();
            _bloodTypeController.clear();
            _birthDateController.clear();
          });
        } else {
          // Handle other non-FirebaseAuthException errors
          print('Error: $e');
        }
        return null;
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _birthDateController.text = DateFormat("dd-MM-yyyy").format(_birthDate);
      });
    }
  }
}
