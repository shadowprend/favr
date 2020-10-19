import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository {
  // Singleton boilerplate

  final String userID;
  MessageRepository(this.userID);
  // Instance
  final CollectionReference _postCollection = FirebaseFirestore.instance.collection('messages');

  Stream<QuerySnapshot> getPosts() {
    return _postCollection.where("participants", arrayContains: userID).limit(20).orderBy('recenttime', descending: false).snapshots();
  }

  Stream<QuerySnapshot> getPostsPage(DocumentSnapshot lastDoc) {
    return _postCollection.where("participants", arrayContains: userID).startAfterDocument(lastDoc).limit(20).orderBy('recenttime', descending: false).snapshots();
  }

}