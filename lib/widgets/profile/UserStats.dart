import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/data_model/UserStats.dart';

class UserStats extends StatefulWidget {
  final LocalStorage storage;
  UserStats(this.storage);

  @override
  _UserStatsState createState() => _UserStatsState();
}

class _UserStatsState extends State<UserStats> {
  UserInfoStats infoStats;
  @override
  void initState()  {
    super.initState();
    String username = widget.storage.getItem('username')['username'];
    final _user_stats = http.get(Uri.http(BACKEND_PATH_LOCAL, "movie/statsForUser/${username}" ));
    _user_stats.then((value) => {
      setState(() {
        this.infoStats = UserInfoStats.fromJson(jsonDecode(value.body));
      })
    });
  }

  List<Widget> generateStats() {
    List<Widget> stats = [];
    stats.add(
        Text('Horas totales vistas: ' + this.infoStats.hoursWatched.toString(), style: TextStyle(fontSize: 20.0))
    );
    for(int j = 0; j < this.infoStats.gendersWatched.length; j++) {
      stats.add(
        Text(this.infoStats.gendersWatched[j], style: TextStyle(fontSize: 20.0))
      );
    }
    for(int i = 0; i < this.infoStats.directors.length; i++) {
      String directorName = this.infoStats.directors[i][0];
      String filmsWacthed =  this.infoStats.directors[i][1].toString();
      stats.add(
        Text(directorName + ' ' + filmsWacthed, style: TextStyle(fontSize: 20.0))
      );
    }
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: this.infoStats != null ? Column( mainAxisAlignment: MainAxisAlignment.center,
                                          children: this.generateStats(),
                                        )
            : Text(''));
  }
}
