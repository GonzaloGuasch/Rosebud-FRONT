import 'package:flutter/cupertino.dart';

class UserInfoStats {
  List directors;
  int hoursWatched;

  UserInfoStats({@required this.directors, @required this.hoursWatched});

  factory UserInfoStats.fromJson(Map<String, dynamic> userStatsJSON) {
    return UserInfoStats(
        directors: userStatsJSON["listOfDirectors"],
        hoursWatched: userStatsJSON["hoursWatched"]);
  }
}