import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/data_model/UserStats.dart';

class StatsUser extends StatefulWidget {
  final LocalStorage storage;
  final String category;
  final String message;
  StatsUser({this.storage, this.category, this.message});

  @override
  _StatsUserState createState() => _StatsUserState();
}

class _StatsUserState extends State<StatsUser> {
  UserInfoStats infoStats;
  List<Widget> listElements = [];
  Widget widgetStats = Text("");


  @override
  void initState()  {
    super.initState();
    this.getStatsUser();
  }

  void getStatsUser() async {
    String username = widget.storage.getItem('username')['username'];
    final _user_stats = await http.get(Uri.http(BACKEND_PATH_LOCAL, "${widget.category}/statsForUser/${username}" ));
    if(_user_stats.statusCode == 200) {
      if(!mounted){return;}
      setState(() {
        this.infoStats = UserInfoStats.fromJson(jsonDecode(_user_stats.body));
      });
      this.createStatsRows();
    }
  }

  void createStatsRows() {
    List<Widget> listColumn = [];
    for(int i = 0; i < 6; i ++) {
      if(i == 6) {
        listColumn.add(SizedBox(height: 70));
      } else {
        String elementName = "";
        if(this.infoStats.elementAmount.length > i) {
          elementName = this.infoStats.elementAmount[i][0];
        }
        listColumn.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text((1 + i).toString(), style: TextStyle(color: Color(0xffec1fa2), fontSize: 20, fontWeight: FontWeight.w600)),
                  Text(elementName, style: TextStyle(color: Color(0xffd5f971), fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
            )
        );
      }
    }
    Widget row = Row(children: [
      Column(children: listColumn.sublist(0, 3)),
      Padding(
        padding: const EdgeInsets.only(left: 80),
        child: Column(children: listColumn.sublist(3, 6)),
      ),
    ]);
    setState(() {
      this.widgetStats = row;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Text(widget.message, style: TextStyle(color: Color(0xffd5f971), fontSize: 20, fontWeight: FontWeight.w600)),
              ),
              this.widgetStats
            ],
          ),
        )
    );
  }
}
