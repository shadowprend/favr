import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final _auth = auth.FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Future<bool> isUserDataExist() async {
    var docRef = await _firestore.collection("userdata").doc(_userID()).get();
    if (docRef.exists) {
      return true;
    }
    return false;
  }

  String _userID() {
    var user = _auth.currentUser;
    return user.uid;
  }

  void updateUserData(var data) async {
    var isExist = await isUserDataExist();
    final CollectionReference postsRef = _firestore.collection("userdata");
    if (!isExist) {
      await postsRef.doc(_userID()).set(data);
      print(data);
    }
  }
}
