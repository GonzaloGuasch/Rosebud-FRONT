import 'package:flutter/cupertino.dart';

class Movie {
  final String title;
  final String director;

    Movie({@required this.title, @required this.director});

    factory Movie.fromJson(Map<String, dynamic> movieJson) {
      return Movie(
        title: movieJson['title'],
        director: movieJson['director'],
      );
    }
}

