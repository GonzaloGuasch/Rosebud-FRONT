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
    setState(()  {
      Iterable movieJsonList = jsonDecode(_response.body);
      List<Movie> movieResultList =  List<Movie>.from(movieJsonList.map((aMovieJson) => Movie.fromJson(aMovieJson)));
      _movieSearchResult = movieResultList;
    });
  }
  List<Widget> MakeMovieResults(List<Movie> movies) {
    List<Widget> movieList = [];
    int i = 0;
    for(i ; i < movies.length; i++) {
      Movie movieToDraw = movies[i];
      movieList.add(
          MovieCard(
              movie: movieToDraw
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