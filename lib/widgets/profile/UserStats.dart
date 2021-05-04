import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/data_model/UserStats.dart';

class UserStats extends StatefulWidget {
  @override
  _UserStatsState createState() => _UserStatsState();
}

class _UserStatsState extends State<UserStats> {
  UserInfoStats infoStats;
  @override
  void initState()  {
    super.initState();
    final _user_stats = http.get(Uri.http(BACKEND_PATH_LOCAL, "movie/statsForUser/usuario" ));
    _user_stats.then((value) => {
      setState((){
        this.infoStats = UserInfoStats.fromJson(jsonDecode(value.body));
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(this.infoStats != null ? this.infoStats.hoursWatched.toString() : '');
  }
}
