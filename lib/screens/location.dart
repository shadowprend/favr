import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favr/screens/dashboard.dart';
import 'package:favr/screens/signin.dart';
import 'package:favr/utilities/components/location/background.dart';
import 'package:favr/utilities/components/location/locationbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatelessWidget {
  static String id = "location";

  @override
  Widget build(BuildContext context) {
    LocationPermission _permissiongranted;

    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Background(
        snackbar: SnackBar(content: Text("Login successfully")),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "favr uses your location to show the services near you!",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            LocationButton(
                text: "Use Current Location",
                press: () async {
                  await requestPermission();
                  Position position = await getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  var coordinates =
                      Coordinates(position.latitude, position.longitude);
                  List<Address> _address = await Geocoder.local
                      .findAddressesFromCoordinates(coordinates);
                  var data = {
                    "longlat": "${position.longitude}.${position.latitude}",
                    "full address": _address.first.addressLine,
                    "cityslug": _address.first.locality
                  };

                  _firestore
                      .collection("userdata")
                      .doc(_auth.currentUser.uid)
                      .update(data);
                  Navigator.pushNamed(context, Dashboard.id);
                  LocationPermission permission = await checkPermission();
                  if (permission == true) {
                    Navigator.pushNamed(context, Dashboard.id);
                  }

                  // if (_permissiongranted == LocationPermission.denied) {
                  //   await openLocationSettings();
                  // }
                  // if (_permissiongranted == LocationPermission.deniedForever) {
                  //   await openAppSettings();
                  // }
                }),
          ],
        ));
  }
}
