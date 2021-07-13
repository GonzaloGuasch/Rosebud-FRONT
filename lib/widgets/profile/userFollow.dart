import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/data_model/UserData.dart';
import 'package:http/http.dart' as http;

import 'VisitUserProfile.dart';

class UserFollow extends StatefulWidget {
  final String username;
  final bool isFollowersOfUsers;
  final LocalStorage storage;
  final Function callback;
  UserFollow(this.username, this.isFollowersOfUsers, this.storage, this.callback);

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
            callback: widget.callback,
            storage: widget.storage,
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
      backgroundColor: Color(0xff1a1414),
      appBar: AppBar(
        shape: Border(bottom: BorderSide(color: Color(0xffec1fa2), width: 2)),
        iconTheme: IconThemeData(color: Color(0xffec1fa2)),
        title: widget.isFollowersOfUsers ? Text('Seguidores', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xffd5f971))) :  Text('Seguidos', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xffd5f971))),
        backgroundColor: Color(0xff1a1414),
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
  final LocalStorage storage;
  final Function callback;
  const FollowerUserButton({this.usernameFollower, this.username, this.isFollowersOfUsers, this.storage, this.callback});

  @override
  _FollowerUserButtonState createState() => _FollowerUserButtonState(this.isFollowersOfUsers);
}

class _FollowerUserButtonState extends State<FollowerUserButton> {
  bool dejoDeSeguir;
  _FollowerUserButtonState(this.dejoDeSeguir);

  void updateDejoDeSeguir() {
    if(!mounted){ return; }
    setState(() {
      dejoDeSeguir = true;
    });
    widget.callback();
  }

  void updateEmpezoASeguir() {
    if(!mounted){ return; }
    setState(() {
      dejoDeSeguir = false;
    });
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 388,
        padding: const EdgeInsets.only(top: 20, left: 3),
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xffec1fa2)),
            )
        ),
        child: this.dejoDeSeguir ?
        SeguirAButton(
            storage: widget.storage,
            username: widget.username,
            usernameFollower: widget.usernameFollower,
            callbackFunction: this.updateEmpezoASeguir
        ) :
        DejarDeSeguirButtonm(
            storage: widget.storage,
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
  final LocalStorage storage;
  const DejarDeSeguirButtonm({Key key, this.usernameFollower, this.username, this.callbackFunction, this.storage}) : super(key: key);

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
                    MaterialPageRoute(builder: (context) => VisitUserProfile(this.usernameFollower, this.storage))
                );
              },
              child: Text(this.usernameFollower, style: TextStyle(fontSize: 20, color: Color(0xffd5f971))),
            )
        ),
        Padding(
          padding: const EdgeInsets.only(left: 145),
          child: TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                        side: BorderSide(color: Color(0xffd5f971))
                    )
                )
            ),
            onPressed: () async {
              final response = await http.post(Uri.http(BACKEND_PATH_LOCAL, "user/dejarDeseguirA/${usernameFollower}/${username}"));
              if (response.statusCode == 200) {
                this.callbackFunction();
              }
            },
            child: Text('Dejar de seguir', style: TextStyle(color: Color(0xffd5f971), fontWeight: FontWeight.w500)),
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
  final LocalStorage storage;
  const SeguirAButton({Key key, this.usernameFollower, this.username, this.callbackFunction, this.storage}) : super(key: key);

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
                    MaterialPageRoute(builder: (context) => VisitUserProfile(this.usernameFollower, this.storage))
                );
              },
          child: Text(this.usernameFollower, style: TextStyle(fontSize: 20, color: Color(0xffd5f971))),
          )
        ),
        Padding(
          padding: const EdgeInsets.only(left: 180),
          child: TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                        side: BorderSide(color: Color(0xffd5f971))
                    )
                )
            ),
            onPressed: () {
              final response = http.post(Uri.http(BACKEND_PATH_LOCAL, "user/seguirA/${usernameFollower}/${username}"));
              response.then(this.callbackFunction());
            },
            child: Text('Seguir', style: TextStyle(color: Color(0xffd5f971), fontWeight: FontWeight.w500)),
          ),
        )
      ],
    );
  }
}

