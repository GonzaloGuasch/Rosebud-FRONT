import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/widgets/profile/userProfile.dart';

class LeaveReview extends StatefulWidget {
  final String ttile;
  final String category;
  final LocalStorage storage;
  final Function callback;
  const LeaveReview({Key key, this.ttile, this.storage, this.category, this.callback}) : super(key: key);

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
                          MaterialPageRoute(builder: (context) => widget.storage.getItem('username') != null ? AddReview(widget.ttile, widget.category, widget.storage, widget.callback) :  RegisterUserProfile(widget.storage))
                      );
                    },
                    child: Row(
                      children: [
                          Icon(Icons.person, size: 50),
                          Text("Deja una review!", style: TextStyle(color: Colors.white, fontSize: 22.0))
                      ],
                    ),
                )
        )
    );
  }
}


class AddReview extends StatefulWidget {
  final String title;
  final String category;
  final LocalStorage storage;
  final Function callback;
  AddReview(this.title, this.category, this.storage, this.callback);
  
  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  bool contieneSpoiler = false;
  TextEditingController _textEditingController = TextEditingController();

  void sendReview() {
    String usernameFromLocalStorage = widget.storage.getItem('username')['username'];
    var body =  json.encode({"elementTitle": widget.title,
                             "username": usernameFromLocalStorage,
                             "review": _textEditingController.text,
                             "hasSpoilers": this.contieneSpoiler });

    final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "${widget.category}/leaveReview"),
                      headers: { 'Content-type': 'application/json', 'Accept': 'application/json'},
                       body: body);
    _response.then((value) => {widget.callback(context)});
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
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.only(top: 1, right: 1, left: 1, bottom: 1),
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 2, color: Colors.white)),
                      child: IconButton(icon: Icon(Icons.check, size: 20.0, color: Colors.white),
                              onPressed: () {
                                  setState(() {
                                    this.contieneSpoiler = !this.contieneSpoiler;
                                  });
                              })
                          ) :
                  Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.only(top: 1, right: 1, left: 1, bottom: 1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 2, color: Colors.white)),
                      child: IconButton(icon: Icon(Icons.clear, size: 20.0, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              this.contieneSpoiler = !this.contieneSpoiler;
                            });
                          })
                  ),
              Text("Contiene spoiler", style: TextStyle(color: Colors.white, fontSize: 30.0))
            ],
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
               if(_textEditingController.text.isNotEmpty) {
                 this.sendReview();
               }
            },
            child: Text('Agregar review'),
          )
        ],
      )
    );
  }
}
