import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/data_model/UserData.dart';
import 'UserStats.dart';

class DataProfile extends StatelessWidget {
 final String amount;
 final String category;
 const DataProfile(this.amount, this.category, {Key key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(this.amount, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        Text(this.category, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))
      ],
    );
  }
}
class DataRow extends StatefulWidget {
  @override
  _DataRowState createState() => _DataRowState();
}

class _DataRowState extends State<DataRow> {
  int data;

  Future<String> userDataAsync() async {
    final _userData = await http.get(Uri.http(BACKEND_PATH_LOCAL, "user/info/usuario" ));
    return _userData.body;
  }


  @override
  Widget build(BuildContext context) {
    final _value = this.userDataAsync();
    return SizedBox(
      child: FutureBuilder<String>(
          future: _value,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              var userData = UserData.fromJson(jsonDecode(snapshot.data));
              children = [
                DataProfile(userData.moviesWatched.toString(), 'vistas'),
                DataProfile(userData.followers.toString(), 'seguidores'),
                DataProfile(userData.following.toString(), 'seguidos'),
              ];
            } else {
              children = [
                DataProfile('0', 'vistas'),
                DataProfile('0', 'seguidores'),
                DataProfile('0', 'seguidos')
              ];
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: children
            );
          },
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DataRow(),
            UserStats()
          ],
        ),
      ),
    );
  }
}
