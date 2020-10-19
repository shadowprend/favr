import 'package:algolia/algolia.dart';
import 'package:favr/utilities/Initiate.dart';

class Services {
  Algolia algolia = AppInitiate.algolia;
  final String search = '';
  int offset = 0;
  int length = 20;

  Future<AlgoliaQuerySnapshot> find(search) async {
    AlgoliaQuery query = algolia.instance
        .index('fav')
        .search(search)
        .setOffset(offset)
        .setLength(length);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    return snap;
  }

  Future<AlgoliaQuerySnapshot> recommendation(attributes) async {
    AlgoliaQuery query = algolia.instance
        .index('fav')
        .search(search)
        .setOffset(offset)
        .setLength(length)
        .setAttributesToRetrieve(attributes);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    return snap;
  }

  setOffset(int value) {
    offset = value;
  }

  setLength(int value) {
    length = value;
  }
}
