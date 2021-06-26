import 'package:flutter/cupertino.dart';

class UserInfoStats {
  List<dynamic> elementAmount;
  List genders;
  int hours;
  UserInfoStats({@required this.elementAmount, @required this.genders, @required this.hours});

  factory UserInfoStats.fromJson(Map<String, dynamic> userStatsJSON) {
    return UserInfoStats(
        elementAmount: userStatsJSON["elementAmount"],
        genders: userStatsJSON["genders"],
        hours: userStatsJSON["hours"]);
  }
}