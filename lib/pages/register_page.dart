import 'package:bitirme_projesi/routes.dart';
import 'package:bitirme_projesi/services/cloud_database/firebase_cloud_user_crud.dart';
import 'package:bitirme_projesi/utilities/dialogs/email_already_in_use_dialog.dart';
import 'package:bitirme_projesi/utilities/dialogs/user_created_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitirme_projesi/user_auth/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  State<RegisterUser> createState() => _MyFormState();
}

class _MyFormState extends State<RegisterUser> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseCloudStorage _firestore = FirebaseCloudStorage();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  late DateTime _birthDate = DateTime.now();
  String? _selectedBloodType;

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
                context, loginPageRoute, (route) => false);
          },
          iconSize: 50,
          color: const Color(0xFFCC4646),
        ),
      ),
      body: GestureDetector(
        onTap: () {
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
              image: AssetImage("lib/assets/bg5.jpg"),
              alignment: Alignment.center,
              fit: BoxFit.contain,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            controller: _fullNameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFCC4646)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(255, 255, 255, 0.7),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 3.0,
                                horizontal: 10,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  _showNameWarning = true;
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFCC4646)),
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
                          DropdownButtonFormField<String>(
                            value: _selectedBloodType,
                            items: [
                              "A Rh+",
                              "A Rh-",
                              "B Rh+",
                              "B Rh-",
                              "AB Rh+",
                              "AB Rh-",
                              "0 Rh+",
                              "0 Rh-",
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value ?? ""),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedBloodType = value;
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFCC4646)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(255, 255, 255, 0.7),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 3.0,
                                horizontal: 10,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  _showBloodWarning = true;
                                  _selectedBloodType = null;
                                });
                              }
                              return null;
                            },
                          ),
                          if (_showBloodWarning)
                            const Text(
                              'Lütfen kan grubu seçin',
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
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFCC4646)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(255, 255, 255, 0.7),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 3.0,
                                horizontal: 10,
                              ),
                              hintText: '(5--)',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  _showPhoneNumberWarning = true;
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
                          const SizedBox(height: 10),
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
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFCC4646)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(255, 255, 255, 0.7),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 3.0,
                                horizontal: 10,
                              ),
                              hintText: 'name@gmail.com',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  _showEmailWarning = true;
                                });
                              } else if (!value.contains('@')) {
                                return 'Geçerli bir e-posta adresi girin';
                              }
                              return null;
                            },
                          ),
                          if (_showEmailWarning)
                            const Text(
                              'Lütfen e-mail girin',
                              style: TextStyle(
                                color: Color(0xFFCC4646),
                                fontSize: 12,
                              ),
                            ),
                          const SizedBox(height: 10),
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
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFCC4646)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(255, 255, 255, 0.7),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 3.0,
                                horizontal: 10,
                              ),
                              hintText: '***',
                            ),
                            validator: (value) {
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
                              'Lütfen şifre girin',
                              style: TextStyle(
                                color: Color(0xFFCC4646),
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCC4646),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minimumSize: const Size(180, 50),
                        ),
                        child: const Text(
                          'Kaydol',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
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
            documentId: ownerUserId,
            name: _fullNameController.text,
            phoneNumber: _phoneNumberController.text,
            birthDate: _birthDateController.text,
            blood: _selectedBloodType!,
          );
          userCreatedDialog(context, "user is succesfully created");
          print("user is succesfully created");
          print(user.toString());

          Navigator.pushNamedAndRemoveUntil(
              context, loginPageRoute, (route) => false);
          setState(() {
            _emailController.clear();
            _passwordController.clear();
            _fullNameController.clear();
            _phoneNumberController.clear();
            _birthDateController.clear();
          });
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            print('The email address is already in use by another account.');
            showEmailAlreadyInUseDialog(context,
                'The email address is already in use by another account.');
          } else {
            print('Firebase Authentication Error: ${e.message}');
          }
          setState(() {
            _emailController.clear();
            _passwordController.clear();
            _fullNameController.clear();
            _phoneNumberController.clear();
            _birthDateController.clear();
          });
        } else {
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
