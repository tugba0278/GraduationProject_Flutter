import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Örneğin, kullanıcı bilgilerini Firestore'a kaydetmek için bir metod
  Future<void> saveUserData(String name, String lastName, String email,
      String phone, String password) async {
    try {
      await _firestore.collection('users').doc().set({
        'name': name,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phone,
        'password': password,
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Firestore'dan kullanıcı bilgilerini almak için bir metod
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      var userData = await _firestore.collection('users').doc().get();
      return userData.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
}
