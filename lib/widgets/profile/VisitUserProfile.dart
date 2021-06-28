import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';

import 'ReviewUserProfile.dart';

class VisitUserProfile extends StatefulWidget {
  final String userName;
  final LocalStorage storage;
  VisitUserProfile(this.userName, this.storage);

  @override
  _VisitUserProfileState createState() => _VisitUserProfileState(this.userName);
}

class _VisitUserProfileState extends State<VisitUserProfile> {
  final String username;
  Widget reviews = Text("");
  bool sigueAUsuario = false;
  List<dynamic> amountReviews;
  _VisitUserProfileState(this.username);

  @override
  void initState()  {
    super.initState();
    this.getUserData();
  }

  void getUserData() async {
    String username = widget.storage.getItem('username')['username'];

    final _userData =  await http.get(Uri.http(BACKEND_PATH_LOCAL, "user/getDataVisitProfile/${this.username}"));
    final _sigueAUsuario = await  http.get(Uri.http(BACKEND_PATH_LOCAL, "user/sigueA/${username}/${this.username}"));
      setState(() {
        this.amountReviews = jsonDecode(_userData.body);
        this.sigueAUsuario = jsonDecode(_sigueAUsuario.body);
      });
    this.createReviews();
  }


  void createReviews() {
     List<Widget> widgetReview = [];
     this.amountReviews.forEach((element) {
       print(element);
       widgetReview.add(ReviewUserProfile(element));
     });

     Widget row = Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: widgetReview);
     setState(() { reviews = row; });
  }

  void seguirAUsuario() {
    String username = widget.storage.getItem('username')['username'];
    final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "user/seguirA/${this.username}/${username}"),
                          headers: { 'Content-type': 'application/json', 'Accept': 'application/json'},
                         );
    _response.then((value) => {
      setState(() {
          this.sigueAUsuario = true;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 300),
            child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(this.username + " publico " + this.amountReviews.length.toString() + " reviews",
                style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w700)),
          ),
          this.sigueAUsuario ? Text("Lo seguis") : IconButton(icon: Icon(Icons.add, size: 30), onPressed: () { this.seguirAUsuario(); }),
          this.reviews
        ],
      )
    );
  }
}
