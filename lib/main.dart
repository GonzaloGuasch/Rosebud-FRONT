import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(RosebudApp());
}

class RosebudApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeChoice(),
    );
  }
}

class HomeChoice extends StatefulWidget {
  @override
  _HomeChoiceState createState() => _HomeChoiceState();
}

class _HomeChoiceState extends State<HomeChoice> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
            child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.movie, size: 50),
                    tooltip: 'Movie section',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MovieContainer()),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.music_note, size: 50),
                    tooltip: 'Music section',
                    onPressed: () {
                    },
                  ),
                ],
              )
         ),
    );
  }
}

class MovieContainer extends StatefulWidget {
  @override
  _MovieContainerState createState() => _MovieContainerState();
}

class _MovieContainerState extends State<MovieContainer> {
  @override
  void initState() {
    final _response = http.get(Uri.http("10.0.2.2:8080", "movie/"));

    _response.then((value) => print(value.body))
             .catchError((onError) => print(onError));

    super.initState();
  }
  List _movieSearchResult = [];

  Future<void> makeSearch(String movieName) async {
    final _response = await http.get(Uri.http("10.0.2.2:8080", "movie/searchByTitle/" + movieName));
    setState(()  {
      _movieSearchResult = jsonDecode(_response.body);
    });
  }
  List<Widget> MakeMovieResults(List movieResultJSON) {
      List<Widget> movieList = [];
      int i = 0;
      for(i ; i < movieResultJSON.length; i++) {
        movieList.add(
           Text(
             movieResultJSON[i]['title'],
               textAlign: TextAlign.center,
           )
        );
      }
      return movieList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children:
                <Widget>[Padding(
                  padding: const EdgeInsets.only(
                                  left: 40,
                                  top: 80,
                                  right: 40,
                                  bottom: 20,
                                ),
                  child: TextField(
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                                makeSearch(value);
                            },
                            decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Titulo de la pelicula'
                                    ),
                            onChanged: (text) {
                              print("First text field: $text");
                            },
                            ),
                ),
                Column(
                   children:  _movieSearchResult.length != 0 ? MakeMovieResults(_movieSearchResult).toList() : []
                ),
                ]
      ),
    );
  }
}
