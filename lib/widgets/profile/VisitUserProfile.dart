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
  List<dynamic> reviewsFromUser;
  _VisitUserProfileState(this.username);

  @override
  void initState()  {
    super.initState();
    this.getUserData();
  }

  void getUserData() async {
    String username = "";
    if(widget.storage.getItem('username') != null) {
      username = widget.storage.getItem('username')['username'];
    }
    final _userData =  await http.get(Uri.http(BACKEND_PATH_LOCAL, "user/getDataVisitProfile/${this.username}"));
    final _sigueAUsuario = await  http.get(Uri.http(BACKEND_PATH_LOCAL, "user/sigueA/${username}/${this.username}"));
      setState(() {
        this.reviewsFromUser = jsonDecode(_userData.body);
        this.sigueAUsuario = jsonDecode(_sigueAUsuario.body);
      });
    this.createReviews();
  }


  void createReviews() {
     List<Widget> widgetReview = [];
     this.reviewsFromUser.forEach((element) { widgetReview.add(ReviewUserProfile(element)); });
     Widget row = Column(mainAxisAlignment: MainAxisAlignment.center,
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
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xffd5f971)),
          backgroundColor: Color(0xff1a1414),
          title: Text("Perfil de: ", style: TextStyle(color: Color(0xffd5f971))),
        ),
      body:
      Container(
        color: Color(0xff1a1414),
        child:
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60, bottom: 12),
                  child: Text(this.username + " publico " + this.reviewsFromUser.length.toString() + " reviews",
                  style: TextStyle(color: Color(0xffd5f971), fontSize: 20.0,fontWeight: FontWeight.w700)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 140),
                  child: this.sigueAUsuario ? Text("Lo seguis",
                                                    style: TextStyle(color: Color(0xffec1fa2), fontSize: 25))
                                            : IconButton(icon: Icon(Icons.add, size: 30), onPressed: () { this.seguirAUsuario(); }),
                ),
                this.reviews
              ],
            ))
    );
  }
}
