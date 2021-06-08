import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rosebud_front/data_model/Movie.dart';

import 'MovieDetail.dart';


class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieDetail(this.movie)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: EdgeInsets.only(bottom: 20.0), height: 100.0, width: 312.0,
          decoration: BoxDecoration(border: Border.all()),
          child: Text(this.movie.title),
        )
    );
  }
}