import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';

class MovieDescriptionInfo extends StatefulWidget {
  final String movieTitle;
  final String movieDirector;
  final String movieDescription;
  final LocalStorage storage;
  const MovieDescriptionInfo({Key key, this.movieTitle, this.movieDirector, this.movieDescription, this.storage}) : super(key: key);
  @override
  _MovieDescriptionInfoState createState() => _MovieDescriptionInfoState(this.movieTitle, this.movieDirector, this.movieDescription);
}

class _MovieDescriptionInfoState extends State<MovieDescriptionInfo> {
  final String movieTitle;
  final String movieDirector;
  final String movieDescription;

  _MovieDescriptionInfoState(this.movieTitle, this.movieDirector, this.movieDescription);



  @override
  Widget build(BuildContext context) {

    return Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 14.0, top: 3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(this.movieTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0, color: Colors.white)),
                  MovieWatched(
                    storage: widget.storage,
                    movieTitle: this.movieTitle
                  ),
                  ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("DIRECTED BY", style: TextStyle(fontSize: 19.0, color: Color(0xff9ea7ae))),
                    Text(this.movieDirector, style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w700, color: Color(0xff9dabb8))),
                  ],
                ),
              ),
              Row(
                children: [
                  Text("1984", style: TextStyle(fontSize: 20.0, color: Color(0xff9ea7ae))),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text("108 mins", style: TextStyle(fontSize: 20.0, color: Color(0xff9ea7ae))),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 20.0),
                child: Text(this.movieDescription, style: TextStyle(fontSize: 18.0, color: Colors.white)),
              )
            ],
          ),
        ),
      );
  }
}


class MovieWatched extends StatefulWidget {
  final String movieTitle;
  final LocalStorage storage;
  const MovieWatched({Key key, this.movieTitle, this.storage}) : super(key: key);

  @override
  _MovieWatchedState createState() => _MovieWatchedState(this.movieTitle);
}

class _MovieWatchedState extends State<MovieWatched> {
   String movieTitle;
   bool isInList = false;
  _MovieWatchedState(this.movieTitle);

   @override
   void initState() {
     super.initState();
     this.updateButtonIcon();
   }

   void updateButtonIcon() async {
     String username = widget.storage.getItem('username')['username'];
     final _isInList = await http.get(Uri.http(BACKEND_PATH_LOCAL, "user/isMovieInList/${this.movieTitle}/${username}"));
     if(_isInList.statusCode == 200) {
       setState(()  {
         this.isInList = jsonDecode(_isInList.body);
       });
     }
   }

  @override
  Widget build(BuildContext context) {
    String username = widget.storage.getItem('username')['username'];
    return Container(
      child:  IconButton(
                icon: this.isInList ? Icon(Icons.check, color: Colors.green) : Icon(Icons.add, color: Colors.white),
                onPressed: () {
                      var body = json.encode({"username":  username, "elementTitle": this.movieTitle});
                      final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "movie/addToWachtedList/"),
                                        headers: { 'Content-type': 'application/json', 'Accept': 'application/json'},
                                        body: body);
                     _response.then((value) => setState(() { this.isInList = jsonDecode(value.body); })
                     );
              }),
    );
  }
}

