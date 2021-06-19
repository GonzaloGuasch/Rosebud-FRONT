import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/data_model/Movie.dart';
import 'package:rosebud_front/widgets/facade/ElementCard.dart';

class MovieUtil {

  static Future<List<ElementObject>> makeMovieResult(String movieName) async {
    final _response = await http.get(Uri.http(BACKEND_PATH_LOCAL, "movie/searchByTitle/" + movieName));
    List movieJsonList;
    List<ElementObject> movieResultList = [];
    movieJsonList = jsonDecode(  _response.body);
    movieResultList =  List<ElementObject>.from(movieJsonList.map((aMovieJson) => Movie.fromJson(aMovieJson)));

    return movieResultList;
  }

  static Widget createAllResults(List<ElementObject> movieSearchResult, LocalStorage storage) {
    List<Widget> list = [];
    for(int i = 0; i < movieSearchResult.length; i++) {
      Movie movieCardResult = movieSearchResult[i];
      list.add(
        ElementCard(
            element: movieCardResult,
            storage: storage,
            isMoveCard: true,
        ),
      );
    }
    return new Column(children: list);
  }
}