import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:http/http.dart' as http;

import 'UserStats.dart';


class DataProfile extends StatelessWidget {
 final String amount;
 final String category;
 const DataProfile(this.amount, this.category, {Key key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(this.amount, style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)),
        Text(this.category, style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold))
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
  @override
  void initState()  {
    super.initState();
    final _user_data = http.get(Uri.http(BACKEND_PATH_LOCAL, "user/info/usuario" ));
    _user_data.then((value) => {
      setState(() {this.data = jsonDecode(value.body); })});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DataProfile(this.data.toString(), 'vistas'),
          DataProfile('0', 'seguidores'),
          DataProfile('0', 'seguidos'),
        ],
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
