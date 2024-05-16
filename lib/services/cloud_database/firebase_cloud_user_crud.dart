// moving away from the local database

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitirme_projesi/services/cloud_database/cloud_constants.dart';
import 'package:bitirme_projesi/services/cloud_database/cloud_user_exceptions.dart';

class FirebaseCloudStorage {
  // Making [FirebaseCloudStorage] a singleton
  // First, create a private constructor
  // We could name this anything but since it is a singleton and there is only
  // going to be one instance and that instance is going to be shared, the
  // _sharedInstance name fits.
  FirebaseCloudStorage._sharedInstance();
  // Secondly, create a private instance
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  // Then, we create a factory constructor, which is the default constructor
  // [FirebaseCloudStorage], using that private shared instance [_shared].
  factory FirebaseCloudStorage() => _shared;

  // Grabbing all the notes, a [CollectionReference] is like a stream for both,
  // reading and writing
  final users = FirebaseFirestore.instance.collection(usersCollectionName);
  final ownerUserId = FirebaseAuth.instance.currentUser?.uid;

  // CRUD
  // C: A function to create new notes
  Future<void> createNewUser({
    required String documentId,
    required String ownerUserId,
    required String name,
    required String phoneNumber,
    required String birthDate,
    required String blood,
  }) async {
    // Firestore is a NoSQL database, it is document based. There is no real
    // like in SQLite. You provide key-value pairs [Map]s. Everything that is
    // added to the Collection/Database is going to be packaged into a document,
    // with the fields (keys) and the values (values) that we have provided.
    const String diseaseInfo = "";
    const String kilo = "";
    const String lastBloodDonationDate = "";
    const String adress = "";

    await users.doc(documentId).set({
      ownerUserIdFieldName: ownerUserId,
      nameFieldName: name,
      phoneNumberFieldName: phoneNumber,
      birthDateFieldName: birthDate,
      bloodFieldName: blood,
      diseaseInfoFieldName: diseaseInfo,
      kiloFieldName: kilo,
      lastBloodDonationDateFieldName: lastBloodDonationDate,
      adressFieldName: adress,
    });
  }

  // U: A function to update fullname
  Future<void> updateFullName({
    required documentId,
    required String name,
    required String lastname,
  }) async {
    try {
      await users
          .doc(documentId)
          .update({nameFieldName: name, lastNameFieldName: lastname});
    } catch (e) {
      throw CouldNotUpdateFullNameException();
    }
  }

  // U: A function to update a given field
  Future<void> updateField({
    required documentId,
    required String fieldName,
    required String fieldValue,
  }) async {
    try {
      await users.doc(documentId).update({fieldName: fieldValue});
    } catch (e) {
      throw CouldNotUpdateFullNameException();
    }
  }

  // D: A function to delete user
  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await users.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteUserException();
    }
  }
}
