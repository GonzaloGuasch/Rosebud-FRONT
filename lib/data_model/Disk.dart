import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'Movie.dart';

class Disk extends ElementObject {
  final String title;
  final String band;
  int raiting;
  final List<Review> reviews;
  final Image diskImage;

  Disk({@required this.title, @required this.band, @required this.reviews, @required this.raiting, @required this.diskImage});

  factory Disk.fromJson(Map<String, dynamic> diskJson) {
    List<Review> diskReview =  List<Review>.from(diskJson['reviews'].map((aMovieReviewJson) => Review.fromJson(aMovieReviewJson)));
    Image movieBASE64Image = Image.memory(base64Decode(diskJson['imagen']));
    return Disk(
      title: diskJson['title'],
      band: diskJson['band'],
      raiting: diskJson['raiting'],
      reviews: diskReview,
      diskImage: movieBASE64Image,
    );
  }
}