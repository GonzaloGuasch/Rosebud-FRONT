import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rosebud_front/data_model/Movie.dart';
import 'MovieDescriptionInfo.dart';
import 'MoviePointReview.dart';
import 'MovieReviewsFromUser.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;
  const MovieDetail(this.movie, {Key key}) : super(key : key);

  @override
  _MovieDetailState createState() => _MovieDetailState(movie);
}

class _MovieDetailState extends State<MovieDetail> {
  Movie movie;
  _MovieDetailState(this.movie);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xff181b20),
      child: ListView(
        children: [
          Container(
                child: Image(image: this.movie.movieImage.image)
          ),
          Container(
            child:
                MovieDescriptionInfo(
                  movieTitle: this.movie.title,
                  movieDirector: this.movie.director,
                  movieDescription: 'A human soldier is sent from 2029 to 1984 to stop an almost indestructible cyborg killing machine, sent from the same year, which has been programmed to execute a young woman whose unborn son is the key to humanitys future salvation.',
                ),
          ),
          Container(
            child: MoviePointReview(
                    movieTitle: this.movie.title,
                    ratingInMovie: this.movie.raiting.toDouble()
              )
          ),
          Container(
            child: MovieReviewsFromUser(
                    movieTitle: this.movie.title,
                    movieReviews: this.movie.reviews,
            ),
          )
        ],
      ),
    );
  }
}