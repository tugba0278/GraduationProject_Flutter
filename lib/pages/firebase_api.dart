import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final userID = FirebaseAuth.instance.currentUser?.uid;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("token: $fCMToken");
    firestore.collection("tokens").doc(userID).set({
      "token-Id": fCMToken,
    });
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
