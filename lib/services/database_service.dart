import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserDocument({
    required String uid,
    required String username,
    required String email,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getUsernameToEmail(String username) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return null;
      }

      return query.docs.first.get('email') as String;
    } catch (e) {
      print('Error finding username: $e');
      return null;
    }
  }


}