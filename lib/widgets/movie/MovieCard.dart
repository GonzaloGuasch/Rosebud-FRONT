import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/data_model/Movie.dart';

import 'MovieDetail.dart';


class MovieCard extends StatelessWidget {
  final Movie movie;
  final LocalStorage storage;

  const MovieCard({Key key, this.movie, this.storage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieDetail(this.movie, this.storage)),
          );
        },
        child:
        Container(
          margin: const EdgeInsets.all(2.0),
          padding: const EdgeInsets.all(3.0),
          height: 140.0,
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xff33363b)),
              )
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(image: this.movie.movieImage.image, width: 80),
                Text(this.movie.title, style: TextStyle(color: Colors.white, fontSize: 30)),
              ]
          ),
        )
    );
  }
}


