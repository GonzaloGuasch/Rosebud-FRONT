import 'package:flutter/cupertino.dart';

class Movie {
  final String title;
  final String director;
  final List<Review> reviews;

    Movie({@required this.title, @required this.director, @required this.reviews});

    factory Movie.fromJson(Map<String, dynamic> movieJson) {
      print(movieJson);
      List<Review> movieReviews =  List<Review>.from(movieJson['reviews'].map((aMovieReviewJson) => Review.fromJson(aMovieReviewJson)));
      return Movie(
        title: movieJson['title'],
        director: movieJson['director'],
        reviews: movieReviews
      );
    }
}

class Review {
  final String userCreate;
  final String review;

  Review({@required this.userCreate, @required this.review});

  factory Review.fromJson(Map<String, dynamic> reviewJson) {
    return Review(
        userCreate: reviewJson['userCreate'],
        review: reviewJson['review']);
  }
}

