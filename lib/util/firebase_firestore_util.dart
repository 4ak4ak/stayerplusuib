import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreUtil {

  Firestore _firestore;
  CollectionReference _usersCollection;
  CollectionReference _dictionaryCollection;

  FirebaseFirestoreUtil();

  Future<DocumentReference> getUserDocument(String userId) async {
    final usersCollection = await _getUserCollection();
    return usersCollection.document(userId);
  }

  Future<List<DocumentSnapshot>> getUserDocumentByNickname(String nickname) async {
    final usersCollection = await _getUserCollection();
    return usersCollection
        .where('nickname', isEqualTo: nickname)
        .getDocuments()
        .then((quetySnapshot) => quetySnapshot.documents);
  }

  Future<DocumentReference> getDictionaryDocument() async {
    final dictionaryCollectiion = await _getDictionaryCollection();
    return dictionaryCollectiion.document('instance');
  }

  Future<CollectionReference> _getUserCollection() async {
    if (_usersCollection == null) {
      final database = await _getFirestoreDatabase();
      _usersCollection = database.collection('users');
    }
    return _usersCollection;
  }

  Future<CollectionReference> _getDictionaryCollection() async {
    if (_dictionaryCollection == null) {
      final database = await _getFirestoreDatabase();
      _dictionaryCollection = database.collection('dictionary');
    }
    return _dictionaryCollection;
  }

  Future<Firestore> _getFirestoreDatabase() async {
    if (_firestore == null) {
      _firestore = Firestore();
      await _firestore.settings(persistenceEnabled: true, timestampsInSnapshotsEnabled: true);
    }
    return _firestore;
  }
}