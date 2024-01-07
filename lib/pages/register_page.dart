import 'package:bitirme_projesi/routes.dart';
import 'package:bitirme_projesi/services/cloud_database/firebase_cloud_user_crud.dart';
import 'package:bitirme_projesi/utilities/dialogs/email_already_in_use_dialog.dart';
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
  final TextEditingController _nameController =
      TextEditingController(); //adın girileceği text metnin kontrolünü sağlar
  final TextEditingController _lastNameController =
      TextEditingController(); //soyadın girileceği text metnin kontrolünü sağlar
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
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bloodTypeController.dispose();
    _birthDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        //overflow engellenir
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/assets/background_image.png"),
                  alignment: Alignment.center,
                  fit: BoxFit.contain)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                20, 60, 20, 20), //her taraftan bırakılan mesafe ,)
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
                        "AD",
                        style: TextStyle(
                            //text özelleştirme
                            fontSize: 27, //yazı boyutu
                            fontStyle: FontStyle.italic, //yazı italik yapma
                            fontFamily: 'Courier' //yazı tipi
                            ),
                        textAlign: TextAlign.left,
                      ),
                      TextFormField(
                        style: const TextStyle(
                            //textformfield özelleştirme
                            fontSize: 20, //yazı boyutu
                            fontStyle: FontStyle.italic, //yazı italik yapma
                            fontFamily: 'Courier', //yazı tipi
                            fontWeight: FontWeight.bold, //yazı kalınlaştırma
                            color: Colors.black //yazı rengi
                            ),
                        controller: _nameController, //tam ad içeriği kontrolü
                        decoration: const InputDecoration(
                          //input kutucuğu özelleştirme
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.zero), //kutucuk kenarları ovallik 0
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCC4646)),
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                          filled: true,
                          fillColor: Colors.white, //kutucuk rengi
                          contentPadding: EdgeInsets.symmetric(
                            //yazı ve kutucuk arasındaki dikey mesafe
                            vertical: 3.0,
                          ),
                        ),
                        validator: (value) {
                          //tam ad input girilip girilmediğini kontrol eder
                          if (value == null || value.isEmpty) {
                            return 'Lütfen adınızı girin'; //ad girilmediyse bu mesaj iletilir
                          }
                          return null; //ad geçerli
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "SOYAD",
                        style: TextStyle(
                          fontSize: 27,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Courier',
                        ),
                        textAlign: TextAlign.left,
                      ),
                      TextFormField(
                        style: const TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Courier',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.zero,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCC4646)),
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 3.0,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen soyadınızı girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "DOĞUM TARİHİ",
                        style: TextStyle(
                          fontSize: 27,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Courier',
                        ),
                        textAlign: TextAlign.left,
                      ),

                      TextFormField(
                        style: const TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Courier',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate(context);
                        },
                        controller: _birthDateController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.zero,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCC4646)),
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 3.0,
                          ),
                          hintText: 'GG-AA-YY',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "KAN GRUBU",
                        style: TextStyle(
                          fontSize: 27,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Courier',
                        ),
                        textAlign: TextAlign.left,
                      ),
                      TextFormField(
                        style: const TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Courier',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        controller: _bloodTypeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.zero,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCC4646)),
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 3.0,
                          ),
                          hintText:
                              'Örneğin: A Rh+', // Kullanıcıya örnek bir yazı
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen kan grubunuzu girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "TELEFON NUMARASI",
                        style: TextStyle(
                            //text özelleştirme
                            fontSize: 27, //yazı boyutu
                            fontStyle: FontStyle.italic, //yazı italik yapma
                            fontFamily: 'Courier' //yazı tipi
                            ),
                        textAlign: TextAlign.left,
                      ),

                      TextFormField(
                        style: const TextStyle(
                            //textformfield özelleştirme
                            fontSize: 20, //yazı boyutu
                            fontStyle: FontStyle.italic, //yazı italik yapma
                            fontFamily: 'Courier', //yazı tipi
                            fontWeight: FontWeight.bold, //yazı kalınlaştırma
                            color: Colors.black //yazı rengi
                            ),
                        controller:
                            _phoneNumberController, //numara içeriği kontrolü
                        keyboardType: TextInputType.phone, //input tipi
                        decoration: const InputDecoration(
                          //input kutucuğu özelleştirme
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.zero), //input kutucuğu ovalliği 0
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCC4646)),
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                          filled: true,
                          fillColor: Colors.white, //kutucuk rengi
                          contentPadding: EdgeInsets.symmetric(
                            //input ve kutucuk arasındaki mesafe
                            vertical: 3.0,
                          ),
                          hintText: '(5--)',
                        ),
                        validator: (value) {
                          //numara input girilip girilmediğini kontrol eder
                          if (value == null || value.isEmpty) {
                            return 'Lütfen telefon numaranızı girin'; //numara girilmediyse bu mesaj iletilir
                          }
                          return null; //numara geçerli
                        },
                      ),
                      const SizedBox(
                          height: 10), //2. kutucuk ve 3. text arasındaki mesafe
                      const Text(
                        "E-MAİL",
                        style: TextStyle(
                            //text özelleştirme
                            fontSize: 27, //yazı boyutu
                            fontStyle: FontStyle.italic, //yazı italik yapma
                            fontFamily: 'Courier' //yazı tipi
                            ),
                        textAlign: TextAlign.left,
                      ),

                      TextFormField(
                        style: const TextStyle(
                            //textformfield özelleştirme
                            fontSize: 20, //yazı boyutu
                            fontStyle: FontStyle.italic, //yazı italik yapma
                            fontFamily: 'Courier', //yazı tipi
                            fontWeight: FontWeight.bold, //yazıkalınlaştırma
                            color: Colors.black //yazı rengi
                            ),
                        controller: _emailController, //e-mail içeriği kontrolü
                        keyboardType: TextInputType.emailAddress, //input tipi
                        decoration: const InputDecoration(
                          //input kutucuğu özelleştirme
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.zero), //kutucuk kenarları ovalliği 0
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCC4646)),
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                          filled: true,
                          fillColor: Colors.white, //kutucuk rengi
                          contentPadding: EdgeInsets.symmetric(
                            //input ve kutucuk arasındaki dikey mesafe
                            vertical: 3.0,
                          ),
                          hintText: 'name@gmail.com',
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
                          height: 10), //3. kutucuk ve 4. text arasındaki mesafe
                      const Text(
                        "PAROLA",
                        style: TextStyle(
                          //text özelleştirme
                          fontSize: 27, //yazı boyutu
                          fontStyle: FontStyle.italic, //yazı itailk yapma
                          fontFamily: 'Courier', //yazı tipi
                        ),
                        textAlign: TextAlign.left,
                      ),

                      TextFormField(
                        style: const TextStyle(
                            //textformfield özelleştirme
                            fontSize: 20, //yazı boyutu
                            fontStyle: FontStyle.italic, //yazı italik yapma
                            fontFamily: 'Courier', //yazı tipi
                            fontWeight: FontWeight.bold //yazı kalınlaştırma
                            ),
                        controller:
                            _passwordController, //parola içeriği kontrolü
                        obscureText: true, //parola içeriği gizleme(*)
                        decoration: const InputDecoration(
                          //input kutucuğu özelleştirme
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.zero), //kutucuk kenarları ovalliği 0
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCC4646)),
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                          filled: true,
                          fillColor: Colors.white, //kutucuk rengi
                          contentPadding: EdgeInsets.symmetric(
                            //text ve kutucuk arasındaki dikey mesafe
                            vertical: 3.0,
                          ),
                          hintText: '***',
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
                              20.0), //kaydol butonu kenarlarının ovalliği
                        ),
                        padding: const EdgeInsets.symmetric(
                            //buton ve kaydol yazısı arasındaki dikey ve yatay mesafe
                            vertical: 5,
                            horizontal: 30),
                      ),
                      child: const Text(
                        'Kaydol',
                        style: TextStyle(
                            //text özelleştirme
                            fontSize: 20, //yazı boyutu
                            fontFamily: 'Calibri', //yazı tipi
                            fontWeight: FontWeight.w500, //yazı kalınlaştırma

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

          _firestore.createNewUser(
            ownerUserId: ownerUserId,
            name: _nameController.text,
            lastName: _lastNameController.text,
            phoneNumber: _phoneNumberController.text,
            birthDate: _birthDateController.text,
            blood: _bloodTypeController.text,
          );

          print("user is succesfully created");
          print(user.toString());
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
              context, loginPageRoute, (route) => false);
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
