import 'package:flutter/cupertino.dart';

class UserInfoStats {
  List directors;
  List gendersWatched;
  int hoursWatched;


  UserInfoStats({@required this.directors, @required this.hoursWatched, @required this.gendersWatched});

  factory UserInfoStats.fromJson(Map<String, dynamic> userStatsJSON) {
    return UserInfoStats(
        directors: userStatsJSON["listOfDirectors"],
        gendersWatched: userStatsJSON["gendersWatched"],
        hoursWatched: userStatsJSON["hoursWatched"]);
  }
}