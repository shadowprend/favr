import 'package:shared_preferences/shared_preferences.dart';

class RecentSearch {
  final String slug;
  RecentSearch(this.slug);

  Future<List<String>> getRecentSearches() async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList(slug);
    return allSearches;
  }

  Future<void> clearRecentSearches() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  Future<void> saveToRecentSearches(String searchText) async {
    if (searchText == null) return; //Should not be null
    final pref = await SharedPreferences.getInstance();

    List<String> services = pref.getStringList(slug);

    if (services?.isNotEmpty ?? false) {
      if (services.length > 5) {
        services.removeLast();
      }
    }

    Set<String> allSearches = services?.toSet() ?? {};

    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList(slug, allSearches.toList());
  }
}
