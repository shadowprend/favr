import 'package:algolia/algolia.dart';
import 'package:favr/screens/servicecontacts.dart';
import 'package:flutter/material.dart';
import 'package:favr/widgets/servicesearch.dart';
import 'recentsearch.dart';
import 'services.dart';

class DataSearch extends SearchDelegate<String> {
  RecentSearch recentsearch = RecentSearch("recentSearches");
  List<String> _oldFilters = const [];
  List<String> localServices = const [];

  serviceRecommendation() {
    Services recommendation = Services();
    return recommendation.recommendation(['name', 'slug']);
  }

  ServicesLength() async {
    localServices = recentsearch.getRecentSearches() as List<String>;
  }

  searchServices(query) {
    Services service = Services();
    service.setLength(6);
    return service.find(query);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    //action for app bar.
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () async {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the app bar.
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    bool isQueryEmpty = query?.trim()?.isEmpty ?? true;

    if (!isQueryEmpty) {
      recentsearch.saveToRecentSearches(query);
    }

    return Column(
      children: <Widget>[
        ServiceSearch(
          query: query,
        )
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
//    recentsearch.clearRecentSearches();
    if (query.isEmpty) {
      return FutureBuilder<List<String>>(
        future: recentsearch.getRecentSearches(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _oldFilters = snapshot.data;
            return ListView.builder(
              itemCount: _oldFilters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.restore),
                  title: Text("${_oldFilters[index]}"),
                  onTap: () {
                    query = _oldFilters[index];
                    showResults(context);
                  },
                );
              },
            );
          } else {
            return Container(
                child: Center(
              child: Text('No recent searches'),
            ));
          }
        },
      );
    } else {
      return FutureBuilder(
        future: searchServices(query),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Container(),
              );
              break;
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.hits.length,
                  itemBuilder: (context, index) {
                    final AlgoliaObjectSnapshot result =
                        snapshot.data.hits[index];
                    return ListTile(
                      leading: Icon(Icons.search),
                      title: Text(result.data['name']),
                      onTap: () {
                        query = result.data['name'];
                        showResults(context);
                      },
                    );
                  },
                );
              }
          }
        },
      );
    }
  }
}
