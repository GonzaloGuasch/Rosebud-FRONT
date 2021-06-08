import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/constants/constants.dart';


// ignore: must_be_immutable
class MoviePointReview extends StatefulWidget {
  String movieTitle;
  double ratingInMovie;
  MoviePointReview({Key key, this.movieTitle, this.ratingInMovie}) : super(key: key);

  @override
  _MoviePointReviewState createState() => _MoviePointReviewState();
}

class _MoviePointReviewState extends State<MoviePointReview> {

  void rateMovie(rating) {
    final rate = rating.toInt();
    final body =  json.encode({'elementTitle': widget.movieTitle, 'rate': rate.toString()});
    final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "movie/rate"),
                      headers: { 'Content-type': 'application/json', 'Accept': 'application/json'},
                      body: body);

    _response.then((value) => {
      setState(() => widget.ratingInMovie = jsonDecode(value.body)['raiting'].toDouble())
    });
    print(widget.ratingInMovie.toString());
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child:
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: widget.ratingInMovie,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                    this.rateMovie(rating);
                },
              ),
            ],
          ),
        ),
    );
  }
}
