import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favr/utilities/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'chatdetailpage.dart';
class SingleProfile extends StatefulWidget {
  static String id = 'singleprofile';
  final Map<String, dynamic> data;
  SingleProfile(this.data);


  @override
  _SingleProfileState createState() => _SingleProfileState();
}

class _SingleProfileState extends State<SingleProfile> {
  String countryCode = '+63';
  String conversationID;
  final _auth = auth.FirebaseAuth.instance;
  final CollectionReference _postCollection = FirebaseFirestore.instance.collection('messages');
  auth.User loggedInUser;


  Future<void> _customLaunch(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('could not lunch $url');
    }
  }


  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.data['name']),
            ),
          ),
          SliverFillRemaining(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                  child: Container(
                    width: 250.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _customLaunch('sms:' + countryCode + widget.data['phonenumber']);
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: getColorFromColorCode('#e8e8e8'),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Align(child: FaIcon(FontAwesomeIcons.solidEnvelope, size: 20.0,)),
                                ),
                                SizedBox(height: 8.0,),
                                Text('SMS', style: TextStyle(fontSize: 13.0),)
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _customLaunch('tel:' + countryCode + widget.data['phonenumber']);
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: getColorFromColorCode('#e8e8e8'),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Align(child: FaIcon(FontAwesomeIcons.phoneAlt, size: 20.0,)),
                                ),
                                SizedBox(height: 8.0,),
                                Text('Call', style: TextStyle(fontSize: 13.0),)
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: '0' + widget.data['phonenumber']));
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: getColorFromColorCode('#e8e8e8'),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Align(child: FaIcon(FontAwesomeIcons.solidCopy, size: 20.0,)),
                                ),
                                SizedBox(height: 8.0,),
                                Text('Copy', style: TextStyle(fontSize: 13.0),)
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async{
                            try {
                              List<String> userID = [widget.data['uid'], loggedInUser.uid];
                              var conversation = await _postCollection.where('participants', whereIn: [[userID[0],userID[1]], [userID[1],userID[0]]]).get();
                              if(conversation.docs.length > 0){
                                for(var c in conversation.docs){
                                  conversationID = c.id;
                                }
                              }else{
                                print('Hi');
                              }
                              print(conversationID);

                            } catch (e) {
                              print(e);
                            }


                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ChatDetailPage(
                            //       receiver: widget.data['uid'],
                            //       name: widget.data['name'],
                            //       details: widget.data['phonenumber'],
                            //       conversationID: '',
                            //     ),
                            //   ),
                            // );
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: getColorFromColorCode('#e8e8e8'),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Align(child: FaIcon(FontAwesomeIcons.solidComment, size: 20.0,)),
                                ),
                                SizedBox(height: 8.0,),
                                Text('Chat', style: TextStyle(fontSize: 13.0),)
                              ],
                            ),
                          ),
                        ),
                        // FaIcon(FontAwesomeIcons.phoneAlt, size: 23.0,),
                        // FaIcon(FontAwesomeIcons.comment, size: 20.0,),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(countryCode+widget.data['phonenumber'], style: TextStyle(fontSize: 16.0),),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Mobile', style: TextStyle(
                                color:
                                getColorFromColorCode('#1d1f23').withOpacity(0.5),
                                fontSize: 13.0)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Servicer Information', style: TextStyle(
                                  color:
                                  getColorFromColorCode('#1d1f23').withOpacity(0.5),
                                  fontSize: 13.0)),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris non tincidunt est, eget aliquet lacus. Praesent faucibus odio elit, ut lobortis est accumsan tempus. Duis convallis ex vel mattis finibus.', style: TextStyle(fontSize: 16.0),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Work Experience', style: TextStyle(
                                  color:
                                  getColorFromColorCode('#1d1f23').withOpacity(0.5),
                                  fontSize: 13.0)),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text('2 years', style: TextStyle(fontSize: 16.0),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
