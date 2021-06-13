import 'package:flutter/cupertino.dart';

class JobOffer {
  final String userAuthor;
  final String description;
  final String location;
  final String linkReference;
  final int durationInWeeks;
  final String title;
  final String remuneration;

  JobOffer({@required this.userAuthor,
           @required this.title,
           @required this.description,
           @required this.location,
           @required this.linkReference,
           @required this.durationInWeeks,
           @required this.remuneration});

  factory JobOffer.fromJson(Map<String, dynamic> JobOfferJson) {
    return JobOffer(
      userAuthor: JobOfferJson['userAuthor'],
      description: JobOfferJson['description'],
      location: JobOfferJson['location'],
      linkReference: JobOfferJson['linkReference'],
      durationInWeeks: JobOfferJson['durationInWeeks'],
      title: JobOfferJson['title'],
      remuneration: JobOfferJson['remuneration'],
    );
  }
}