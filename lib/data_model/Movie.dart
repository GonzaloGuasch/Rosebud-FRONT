import 'package:flutter/cupertino.dart';

class Movie {
  final String title;
  final String director;
  int raiting;
  final List<Review> reviews;

    Movie({@required this.title, @required this.director, @required this.reviews, @required this.raiting});

    factory Movie.fromJson(Map<String, dynamic> movieJson) {
      List<Review> movieReviews =  List<Review>.from(movieJson['reviews'].map((aMovieReviewJson) => Review.fromJson(aMovieReviewJson)));
      return Movie(
        title: movieJson['title'],
        director: movieJson['director'],
        raiting: movieJson['raiting'],
        reviews: movieReviews
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

