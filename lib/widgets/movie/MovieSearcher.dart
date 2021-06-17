import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/data_model/Movie.dart';
import 'package:http/http.dart' as http;

import 'MovieCard.dart';

class MovieSearcher extends StatefulWidget {
  final LocalStorage storage;
  MovieSearcher(this.storage);

  @override
  _MovieSearcherState createState() => _MovieSearcherState();
}

class _MovieSearcherState extends State<MovieSearcher> {
  List _movieSearchResult = [];

  Future<void> makeSearch(String movieName) async {
    final _response = await http.get(Uri.http(BACKEND_PATH_LOCAL, "movie/searchByTitle/" + movieName));
    List movieJsonList = jsonDecode(_response.body);
    List<Movie> movieResultList =  List<Movie>.from(movieJsonList.map((aMovieJson) => Movie.fromJson(aMovieJson)));
    setState(()  {
      _movieSearchResult = movieResultList;
    });
  }

  Widget createAllResults() {
    List<Widget> list = [];
    for(int i = 0; i < this._movieSearchResult.length; i++) {
      Movie movieCardResult = this._movieSearchResult[i];
      list.add(
        MovieCard(
            movie: movieCardResult,
            storage: widget.storage
        ),
      );
    }

    return new Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff445565),
      appBar: AppBar(
        backgroundColor: Color(0xff334454),
        title: const Text('BUSCADOR DE PELIS '),
      ),
      body: Container(
        color: Color(0xff334454),
        child: Column(
          children: [
            TextField(
              key: Key('ElementInputSearch'),
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                makeSearch(value);
              },
              decoration: InputDecoration(
                hintText: 'Titulo de la pelicula',
              ),
            ),
            this.createAllResults()
          ],
        )
      )
    );
  }
}
