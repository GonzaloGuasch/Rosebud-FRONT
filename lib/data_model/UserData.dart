import 'package:flutter/cupertino.dart';

class UserData {
  int moviesWatched;
  int followers;
  int following;


  UserData({@required this.moviesWatched, @required this.followers, @required this.following});

  factory UserData.fromJson(Map<String, dynamic> userStatsJSON) {
    return UserData(
        moviesWatched: userStatsJSON["moviesWatched"],
        followers: userStatsJSON["followers"],
        following: userStatsJSON["following"]);
  }
}

class UserFollowData {
  String username;

  UserFollowData({@required this.username});

  factory UserFollowData.fromJson(Map<String, dynamic> userFollow) {
    return UserFollowData(
        username: userFollow["username"]
    );
  }
}