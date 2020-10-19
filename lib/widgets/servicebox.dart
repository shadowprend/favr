import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:favr/utilities/constant.dart';
import 'package:favr/screens/servicecontacts.dart';

class ServiceBox extends StatelessWidget {
  final String name;
  final String description;
  final String slug;
  final String image;
  ServiceBox({this.name, this.description, this.slug, this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ServiceContacts(
                  title: name,
                  serviceName: slug,
                ),
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150.0,
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                  ),
                  image: DecorationImage(image: NetworkImage(image)),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                          color:
                              getColorFromColorCode('#1d1f23').withOpacity(0.5),
                          fontSize: 13.0),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
