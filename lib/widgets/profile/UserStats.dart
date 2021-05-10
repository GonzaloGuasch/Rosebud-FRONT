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
      setState(() {
        this.infoStats = UserInfoStats.fromJson(jsonDecode(value.body));
      })
    });
  }

  List<Widget> listOfDirectors() {
    int i = 0;
    List<Widget> userDirectorStats = [];
    userDirectorStats.add(
        Text('Horas totales vistas: ' + this.infoStats.hoursWatched.toString(), style: TextStyle(fontSize: 20.0))
    );
    for(i ; i < this.infoStats.directors.length; i++) {
      String directorName = this.infoStats.directors[i][0];
      String filmsWacthed =  this.infoStats.directors[i][1].toString();
      userDirectorStats.add(
        Text(directorName + ' ' + filmsWacthed, style: TextStyle(fontSize: 20.0))
      );
    }
    return userDirectorStats;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: this.infoStats != null ? Column( mainAxisAlignment: MainAxisAlignment.center,
                                          children: this.listOfDirectors(),
                                        )
            : Text(''));
  }
}
