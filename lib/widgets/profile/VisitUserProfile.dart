import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';

class VisitUserProfile extends StatefulWidget {
  final String userName;
  final LocalStorage storage;
  VisitUserProfile(this.userName, this.storage);

  @override
  _VisitUserProfileState createState() => _VisitUserProfileState(this.userName);
}

class _VisitUserProfileState extends State<VisitUserProfile> {
  final String username;
  bool sigueAUsuario = false;
  var amountReviews;
  _VisitUserProfileState(this.username);

  @override
  void initState()  {
    super.initState();
    final _userData =  http.get(Uri.http(BACKEND_PATH_LOCAL, "user/getDataVisitProfile/${this.username}"));

    String username = widget.storage.getItem('username')['username'];
    final _sigueAUsuario = http.get(Uri.http(BACKEND_PATH_LOCAL, "user/sigueA/${username}/ ${this.username}"));

    _userData.then((value) => {
      setState(() {
        this.amountReviews = jsonDecode(value.body);
      }),
    });
    _sigueAUsuario.then((loSigue) =>
        setState(() {
          this.sigueAUsuario = jsonDecode(loSigue.body);
        })
      );
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
            child: Text(this.username + " publico " + this.amountReviews.toString() + " reviews",
                style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w700)),
          ),
          this.sigueAUsuario ? Text("Lo seguis") : IconButton(icon: Icon(Icons.add, size: 30), onPressed: () { this.seguirAUsuario(); },)
        ],
      )
    );
  }
}
