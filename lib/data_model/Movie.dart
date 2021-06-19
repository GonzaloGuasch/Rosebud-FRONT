import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';


class ElementObject {

}


class Movie extends ElementObject {
  final String title;
  final String director;
  int raiting;
  final List<Review> reviews;
  final Image movieImage;

    Movie({@required this.title, @required this.director, @required this.reviews, @required this.raiting, @required this.movieImage});

    factory Movie.fromJson(Map<String, dynamic> movieJson) {
      List<Review> movieReviews =  List<Review>.from(movieJson['reviews'].map((aMovieReviewJson) => Review.fromJson(aMovieReviewJson)));
      Image movieBASE64Image = Image.memory(base64Decode(movieJson['imagen']));
      return Movie(
        title: movieJson['title'],
        director: movieJson['director'],
        raiting: movieJson['raiting'],
        reviews: movieReviews,
        movieImage: movieBASE64Image,
      );
    }
}

class Review {
  final String userCreate;
  final String review;
  final bool hasSpoilers;
  final int id;

  Review({@required this.userCreate, @required this.review, @required this.hasSpoilers, @required this.id});

  factory Review.fromJson(Map<String, dynamic> reviewJson) {
    return Review(
        userCreate: reviewJson['userCreate'],
        review: reviewJson['review'],
        hasSpoilers: reviewJson['hasSpoilers'],
        id: reviewJson['id']);
  }
}

