import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/constants/constants.dart';

class DiskDescriptionInfo extends StatefulWidget {
  final LocalStorage storage;
  final String diskTitle;
  final String diskBand;
  final String diskDescription;
  final int diskYear;
  DiskDescriptionInfo({this.storage, this.diskBand, this.diskDescription, this.diskTitle, this.diskYear});

  @override
  _DiskDescriptionInfoState createState() => _DiskDescriptionInfoState();
}

class _DiskDescriptionInfoState extends State<DiskDescriptionInfo> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 14.0, top: 3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.diskTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0, color: Color(0xffec1fa2))),
                widget.storage.getItem('username') != null ?  DiskWatched(
                                                                  storage: widget.storage,
                                                                  diskTitle: widget.diskTitle) : Text(""),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("BAND NAME", style: TextStyle(fontSize: 19.0, color: Color(0xff9ea7ae))),
                  Text(widget.diskBand, style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w700, color: Color(0xff9dabb8))),
                ],
              ),
            ),
            Row(
              children: [
                Text(widget.diskYear.toString(), style: TextStyle(fontSize: 20.0, color: Color(0xff9ea7ae))),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text("108 mins", style: TextStyle(fontSize: 20.0, color: Color(0xff9ea7ae))),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 20.0),
              child: Text(widget.diskDescription, style: TextStyle(fontSize: 18.0, color: Color(0xffd5f971))),
            )
          ],
        ),
      ),
    );
  }
}


class DiskWatched extends StatefulWidget {
  final String diskTitle;
  final LocalStorage storage;
  const DiskWatched({Key key, this.diskTitle, this.storage}) : super(key: key);

  @override
  _DiskWatchedState createState() => _DiskWatchedState();
}

class _DiskWatchedState extends State<DiskWatched> {
  bool isInList = false;

  @override
  void initState() {
    super.initState();
    this.updateButtonIcon();
  }

  void updateButtonIcon() async {
    String username = "";
    if(widget.storage.getItem('username') != null) {
      username = widget.storage.getItem('username')['username'];
    }

    final _isInList = await http.get(Uri.http(BACKEND_PATH_LOCAL, "user/isDiskInList/${widget.diskTitle}/${username}"));
    if(_isInList.statusCode == 200) {
      setState(()  {
        this.isInList = jsonDecode(_isInList.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String username = "";
    if(widget.storage.getItem('username') != null) {
      username = widget.storage.getItem('username')['username'];
    }
    return Container(
      child:  IconButton(
          icon: this.isInList ? Icon(Icons.check, color: Colors.green) : Icon(Icons.add, color: Colors.white),
          onPressed: () {
            var body = json.encode({"username":  username, "elementTitle": widget.diskTitle});
            final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "disk/addToWachtedList/"),
                headers: { 'Content-type': 'application/json', 'Accept': 'application/json'},
                body: body);
            _response.then((value) => setState(() { this.isInList = jsonDecode(value.body); })
            );
          }),
    );
  }
}

