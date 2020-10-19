import 'package:algolia/algolia.dart';
import 'package:favr/models/services.dart';
import 'package:favr/widgets/servicebox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceSearch extends StatefulWidget {
  final String query;

  ServiceSearch({@required this.query});

  @override
  _ServiceSearchState createState() => _ServiceSearchState();
}

class _ServiceSearchState extends State<ServiceSearch> {
  List<AlgoliaObjectSnapshot> _services = [];
  bool loading = true;
  ScrollController _scrollController = ScrollController();

  _getService() async {
    Services service = new Services();
    service.setLength(20);
    var services = await service.find(widget.query);
    _services = services.hits;
    setState(() {
      loading = false;
    });
  }

  _getMoreServices() async {
    Services moreServices = new Services();
    moreServices.setLength(20);
    moreServices.setOffset(_services.length);
    var services = await moreServices.find(widget.query);
    _services.addAll(services.hits);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getService();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        _getMoreServices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading == true
          ? Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _services.length == 0
              ? Expanded(
                  child: Center(
                    child: Text("No products to show"),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(15.0),
                    controller: _scrollController,
                    itemCount: _services.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ServiceBox(
                          name: _services[index].data['name'],
                          description: _services[index].data['description'],
                          slug: _services[index].data['slug']);
                    },
                  ),
                ),
    );
  }
}
