import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/data_model/UserData.dart';
import 'package:http/http.dart' as http;

import 'VisitUserProfile.dart';

class UserFollow extends StatefulWidget {
  final String username;
  final bool isFollowersOfUsers;
  UserFollow(this.username, this.isFollowersOfUsers);

  @override
  _UserFollowState createState() => _UserFollowState();

}

class _UserFollowState extends State<UserFollow> {
  List<Widget> userFollow = [];

  @override
  void initState() {
    super.initState();
    this.followersOfUser();
  }

  void followersOfUser() async {
    var _userFollowState;
    if(widget.isFollowersOfUsers) {
      _userFollowState = await http.get(Uri.http(BACKEND_PATH_LOCAL, "user/seguidores/" + widget.username));
    } else {
      _userFollowState = await http.get(Uri.http(BACKEND_PATH_LOCAL, "user/seguidos/" + widget.username));
    }
    List _userFollowList = jsonDecode(_userFollowState.body);
    List<UserFollowData> userFollowers =  List<UserFollowData>.from(_userFollowList.map((aMovieJson) => UserFollowData.fromJson(aMovieJson)));
    List<Widget> listOfUsersWidget = [];
    for(int i = 0; i < userFollowers.length; i++) {
      listOfUsersWidget.add(
        FollowerUserButton(
            isFollowersOfUsers: widget.isFollowersOfUsers,
            username: widget.username,
            usernameFollower: userFollowers[i].username
        )
      );
    }
    setState(() {
      userFollow = listOfUsersWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: widget.isFollowersOfUsers ? Text('Seguidores', style: TextStyle(color: Colors.black)) :  Text('Seguidos', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: this.userFollow,
      ),
    );
  }
}

class FollowerUserButton extends StatefulWidget {
  final String usernameFollower;
  final String username;
  final bool isFollowersOfUsers;

  const FollowerUserButton({this.usernameFollower, this.username, this.isFollowersOfUsers});

  @override
  _FollowerUserButtonState createState() => _FollowerUserButtonState(!this.isFollowersOfUsers);
}

class _FollowerUserButtonState extends State<FollowerUserButton> {
  bool dejoDeSeguir;
  _FollowerUserButtonState(this.dejoDeSeguir);

  void updateDejoDeSeguir() {
    setState(() {
      dejoDeSeguir = true;
    });
  }

  void updateEmpezoASeguir() {
    setState(() {
      dejoDeSeguir = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(2.0),
        padding: const EdgeInsets.only(top: 12, left: 3.0),
        height: 50,
        width: 388,
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xff33363b)),
            )
        ),
        child: this.dejoDeSeguir ?
        SeguirAButton(
            username: widget.username,
            usernameFollower: widget.usernameFollower,
            callbackFunction: this.updateEmpezoASeguir
        ) :
        DejarDeSeguirButtonm(
            username: widget.username,
            usernameFollower: widget.usernameFollower,
            callbackFunction: this.updateDejoDeSeguir
        )
    );
  }
}


class DejarDeSeguirButtonm extends StatelessWidget {
  final String usernameFollower;
  final String username;
  final Function callbackFunction;
  const DejarDeSeguirButtonm({Key key, this.usernameFollower, this.username, this.callbackFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VisitUserProfile(this.usernameFollower))
                );
              },
              child: Text(this.usernameFollower, style: TextStyle(fontSize: 20)),
            )
        ),
        Padding(
          padding: const EdgeInsets.only(left: 145),
          child: TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                        side: BorderSide(color: Color(0xffe2e2e2))
                    )
                )
            ),
            onPressed: () {
              final response = http.post(Uri.http(BACKEND_PATH_LOCAL, "user/dejarDeseguirA/" + usernameFollower + "/" + username));
              response.then(this.callbackFunction());
            },
            child: Text('Dejar de seguir', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
          ),
        )
      ],
    );
  }
}


class SeguirAButton extends StatelessWidget {
  final String usernameFollower;
  final String username;
  final Function callbackFunction;
  const SeguirAButton({Key key, this.usernameFollower, this.username, this.callbackFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VisitUserProfile(this.usernameFollower))
                );
              },
          child: Text(this.usernameFollower, style: TextStyle(fontSize: 20)),
          )
        ),
        Padding(
          padding: const EdgeInsets.only(left: 180),
          child: TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                        side: BorderSide(color: Color(0xffe2e2e2))
                    )
                )
            ),
            onPressed: () {
              final response = http.post(Uri.http(BACKEND_PATH_LOCAL, "user/seguirA/" + username + "/" + usernameFollower));
              response.then(this.callbackFunction());
            },
            child: Text('Seguir', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
          ),
        )
      ],
    );
  }
}

