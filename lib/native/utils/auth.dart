import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static void studentIn(
      String email, String password, Function(FirebaseAuthException) onError) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      onError(exception);
    }
  }

  static void studentUp(String email, String password, String code,
      Function(FirebaseException) onError, Function onNotFound) async {
    FirebaseFirestore.instance.collection('codes').where('code', isEqualTo: code).get().then(
        (val) async {
      if (val.docs.isEmpty) {
        onNotFound();
      } else {
        DocumentSnapshot doc = val.docs.first;
        Map<String, String> data = {
          'firstName': doc.get('firstName'),
          'lastName': doc.get('lastName'),
          'role': doc.get('role'),
          'mClass': doc.get('mClass'),
        };
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(value.user.uid)
              .set(data)
              .onError((error, stackTrace) => onError(error));
        }, onError: (error) => onError(error));
      }
    }, onError: (error) => onError(error));
  }
}
