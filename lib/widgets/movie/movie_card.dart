import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/data_model/Movie.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rosebud_front/widgets/review/review.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieScreem(this.movie)),
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

class MovieScreem extends StatefulWidget {
  final Movie movie;
  const MovieScreem(this.movie, {Key key}) : super(key : key);

  @override
  _MovieScreemState createState() => _MovieScreemState(movie);
}

class _MovieScreemState extends State<MovieScreem> {
  Movie movie;
  _MovieScreemState(this.movie);

  void rateMovie(rating) {
    final rate = rating.toInt();
    final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "movie/rate"),
        body: {'movieTitle': this.movie.title, 'rate': rate.toString()});
    //REFRESH DE WIDGET
  }
  void reDraw() async {
    final _response = await http.get(Uri.http(BACKEND_PATH_LOCAL, "movie/searchByTitle/" + this.movie.title));
    setState(()  {
      Iterable movieJsonList = jsonDecode(_response.body);
      List<Movie> movieResultList =  List<Movie>.from(movieJsonList.map((aMovieJson) => Movie.fromJson(aMovieJson)));
      this.movie = movieResultList.first;
    });
  }

  List<Widget> makeMovieReviews(List<Review> reviews) {
    List<Widget> reviewList = [];
    int i = 0;
    for(i ; i < reviews.length; i++) {
      Review reviewToDraw = reviews[i];
      reviewList.add(
          ReviewCard(
            review: reviewToDraw,
            movieTitle: this.movie.title,
            callbackOnDelete: () => { this.reDraw() },
          )
      );
    }
    return reviewList;
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 80),
          Text(this.movie.title,
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
            ),
          ),
          RatingBar.builder(
            initialRating: 3,
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
              rateMovie(rating);
            },
          ),
          Column(
              children:  movie.reviews.length != 0 ? makeMovieReviews(movie.reviews).toList() : []
          ),
        ],
      ),
    );
  }
}