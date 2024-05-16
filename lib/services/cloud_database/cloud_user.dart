import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bitirme_projesi/services/cloud_database/cloud_constants.dart';

class CloudUser {
  final String name;
  final String lastName;
  final String phoneNumber;
  final String documentId;
  final String ownerUserId;
  final String birthDate;
  final String blood;

  CloudUser({
    required this.name,
    required this.lastName,
    required this.phoneNumber,
    required this.documentId,
    required this.ownerUserId,
    required this.birthDate,
    required this.blood,
  });

  CloudUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.data()[ownerUserIdFieldName],
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        name = snapshot.data()[nameFieldName],
        lastName = snapshot.data()[lastNameFieldName],
        phoneNumber = snapshot.data()[phoneNumberFieldName],
        birthDate = snapshot.data()[birthDateFieldName],
        blood = snapshot.data()[bloodFieldName];
}
