// moving away from the local database
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitirme_projesi/services/cloud_database/cloud_constants.dart';
import 'package:bitirme_projesi/services/cloud_database/cloud_user_exceptions.dart';
import 'package:bitirme_projesi/services/cloud_database/cloud_user.dart';

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

  // A [Stream] is a sequence of asynchronous events.
  // It represents a flow of data that you can listen to over time.
  // We need a [Stream] to keep our application up-to-date with changes in the
  // cloud.
  // Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
  //   // .snapshots returns a [Stream] of [QuerySnapshot]s, not just one.
  //   // Each snapshot is an (event) which has a list of all of the documents
  //   // (docs) inside the database.
  //   return notes.snapshots().map((event) => event.docs
  //       // Then from this list of documents, only the documents which belongs
  //       // to the current user is used (to create instances of [CloudNote]).
  //       .map((doc) => CloudNote.fromSnapshot(doc))
  //       // This .where is clause is from dart:core which returns an object based
  //       // on a test, in this case user IDs being equal.
  //       .where((note) => note.ownerUserId == ownerUserId));
  // }

  // CRUD
  // C: A function to create new notes
  Future<CloudUser> createNewUser({
    required String ownerUserId,
    required String name,
    required String lastName,
    required String phoneNumber,
    required String birthDate,
    required String blood,
  }) async {
    // Firestore is a NoSQL database, it is document based. There is no real
    // like in SQLite. You provide key-value pairs [Map]s. Everything that is
    // added to the Collection/Database is going to be packaged into a document,
    // with the fields (keys) and the values (values) that we have provided.
    final user = await users.add({
      nameFieldName: name,
      lastNameFieldName: lastName,
      ownerUserIdFieldName: ownerUserId,
      phoneNumberFieldName: phoneNumber,
      birthDateFieldName: birthDate,
      bloodFieldName: blood,
    });

    final fetchedUser = await user.get();
    return CloudUser(
      name: name,
      lastName: lastName,
      phoneNumber: phoneNumber,
      documentId: fetchedUser.id,
      ownerUserId: ownerUserId,
      birthDate: birthDate,
      blood: blood,
    );
  }

  //R: A function to get user genres by user ID
  // Future<void> getGenres() async {
  //   try {
  //     var querySnapshot = await users
  //         .where(ownerUserIdFieldName,
  //             isEqualTo: FirebaseAuth.instance.currentUser?.uid)
  //         .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       var user = CloudUser.fromSnapshot(querySnapshot.docs.first);
  //       return user.genre;
  //     } else {
  //       // User not found or has no genres
  //       return [];
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     throw CouldNotGetAllUserException();
  //   }
  // }

  // U: A function to update genre
  // Future<void> getInformation({
  //   required documentId,
  //   required String firstText,
  //   required String secondText,
  //   required String thirdText,

  // }) async {
  //   try {
  //     // There must be a logged in user
  //     final querySnapshot = await users
  //         .where(
  //           ownerUserIdFieldName,
  //           isEqualTo: FirebaseAuth.instance.currentUser?.uid,
  //         )
  //         .get();
  //     if (querySnapshot.docs.isNotEmpty) {
  //       final documentId = querySnapshot.docs[0].id;
  //       await users.doc(documentId).update({genreFieldName: genre});
  //       print('Document ID: $documentId');
  //     } else {
  //       print('No matching documents found.');
  //     }
  //   } catch (e) {
  //     print('Error retrieving document ID: $e');
  //     throw CouldNotUpdateGenreException();
  //   }
  // }

  // U: A function to update genre
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

  // U: A function to update genre
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
