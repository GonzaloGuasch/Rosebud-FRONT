import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/constants/constants.dart';

class LeaveReview extends StatefulWidget {
  final String username;
  final String movieTitle;

  const LeaveReview({Key key, this.username, this.movieTitle}) : super(key: key);

  @override
  _LeaveReviewState createState() => _LeaveReviewState();
}

class _LeaveReviewState extends State<LeaveReview> {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color(0xff181b20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15)),
            color: Color(0xff445565),
          ),
          child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddReview(widget.username, widget.movieTitle))
                      );
                    },
                    child: Row(
                      children: [
                          Icon(Icons.person, size: 50),
                          Text("Deja una review si viste la peli!", style: TextStyle(color: Colors.white, fontSize: 22.0))
                      ],
                    ),
                )
        )
    );
  }
}


class AddReview extends StatefulWidget {
  final String username;
  final String movieTitle;

  AddReview(this.username, this.movieTitle);
  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  bool contieneSpoiler = false;
  TextEditingController _textEditingController = TextEditingController();

  void sendReview() {
    var body =  json.encode({"elementTitle": widget.movieTitle,
                             "username": widget.username,
                             "review": _textEditingController.text,
                             "hasSpoilers": this.contieneSpoiler });
    final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "movie/rate"),
                      headers: { 'Content-type': 'application/json', 'Accept': 'application/json'},
                       body: body);
    _response.then((value) => print(value.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color(0xff181b20),
      appBar: AppBar(
        backgroundColor: Color(0xff181b20),
        title: const Text('Deja tu review!'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            color: Color(0xff181b20),
            child: new TextField(
              controller: _textEditingController,
              maxLines: 10,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                  hintText: "Deja tu review",
              ),
            ),
          ),
          Row(
            children: [
              this.contieneSpoiler ?
                  Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.only(top: 10, right: 15, left: 10, bottom: 15),
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 3, color: Colors.white)),
                      child: IconButton( icon: Icon(Icons.check, size: 40.0, color: Colors.white),
                              onPressed: () {
                                  setState(() {
                                    this.contieneSpoiler = !this.contieneSpoiler;
                                  });
                              })
                          ) :
                  Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.only(top: 10, right: 15, left: 10, bottom: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 3, color: Colors.white)),
                      child: IconButton( icon: Icon(Icons.clear, size: 40.0, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              this.contieneSpoiler = !this.contieneSpoiler;
                            });
                          })
                  ),
              Text("Contiene spoiler", style: TextStyle(color: Colors.white, fontSize: 35.0))
            ],
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
                this.sendReview();
            },
            child: Text('Agregar review '),
          )
        ],
      )
    );
  }
}
