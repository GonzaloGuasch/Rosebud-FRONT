import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/constants/constants.dart';

class VisitUserProfile extends StatefulWidget {
  final String userName;
  VisitUserProfile(this.userName);

  @override
  _VisitUserProfileState createState() => _VisitUserProfileState(this.userName);
}

class _VisitUserProfileState extends State<VisitUserProfile> {
  final String username;
  var amountReviews;
  _VisitUserProfileState(this.username);

  @override
  void initState()  {
    super.initState();
    final _response =  http.get(Uri.http(BACKEND_PATH_LOCAL, "user/getDataVisitProfile/" + this.username));
    _response.then((value) => {
      setState(() {
        this.amountReviews = jsonDecode(value.body);
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Text("LAS CANTIDAD DE REVIEWS : " + this.amountReviews.toString()),
    );
  }
}
