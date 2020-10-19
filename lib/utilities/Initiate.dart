import 'package:algolia/algolia.dart';

const appID = '6ZHQQ4NSFM';
const appKey = '7bdc1e9143f3ea398b7950d3f22d9eb9';

class AppInitiate {
  static final Algolia algolia = Algolia.init(
    applicationId: appID,
    apiKey: appKey,
  );
}
