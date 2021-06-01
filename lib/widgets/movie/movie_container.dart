import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/data_model/Movie.dart';

import 'movie_card.dart';


class MovieContainer extends StatefulWidget {
  @override
  _MovieContainerState createState() => _MovieContainerState();
}

class _MovieContainerState extends State<MovieContainer> {
  List _movieSearchResult = [];

  Future<void> makeSearch(String movieName) async {
    final _response = await http.get(Uri.http(BACKEND_PATH_LOCAL, "movie/searchByTitle/" + movieName));
    List movieJsonList = jsonDecode(_response.body);
    List<Movie> movieResultList =  List<Movie>.from(movieJsonList.map((aMovieJson) => Movie.fromJson(aMovieJson)));
    setState(()  {
      _movieSearchResult = movieResultList;
    });
  }

  ListView MakeMovieResults(List<Movie> movies) {
    List<Widget> movieList = [];
    int i = 0;
    for(i ; i < movies.length; i++) {
      Movie movieToDraw = movies[i];
      movieList.add(
          Padding(
            padding: const EdgeInsets.only(left: 37.0, right: 37.0),
            child: MovieCard(
                movie: movieToDraw
            ),
          )
      );
    }
    return ListView(children: movieList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children:
          <Widget>[
            Padding(
          padding: const EdgeInsets.only(top: 80, right: 300),
              child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
              }),
            ),
            Padding(
            padding: const EdgeInsets.only(
              left: 40,
              right: 40,
              bottom: 20.0,
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
            ),
          ),
          Expanded(
                child: _movieSearchResult.length != 0 ? MakeMovieResults(_movieSearchResult) : Text('No hay ningun resultado', style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w300))
              )
          ]
      ),
    );
  }
}