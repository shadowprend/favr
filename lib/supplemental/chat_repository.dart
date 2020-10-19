import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favr/utilities/components/contants.dart';
import 'package:favr/utilities/constant.dart';

class ChatRepository {
  // Singleton boilerplate

  final String conversationID;
  ChatRepository(this.conversationID);

  // static ChatRepository _instance = ChatRepository._();
  // static ChatRepository get instance => _instance;

  // Instance
  final CollectionReference _postCollection =
      FirebaseFirestore.instance.collection('messages');

  Stream<QuerySnapshot> getPosts() {
    return _postCollection
        .doc(conversationID)
        .collection('conversation')
        .limit(chatLimit)
        .orderBy('time', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getPostsPage(DocumentSnapshot lastDoc) {
    return _postCollection
        .doc(conversationID)
        .collection('conversation')
        .orderBy('time', descending: false)
        .limit(chatLimit)
        .startAfterDocument(lastDoc)
        .snapshots();
  }
}
