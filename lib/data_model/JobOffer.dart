import 'package:flutter/cupertino.dart';

class JobOffer {
  final String userAuthor;
  final List<dynamic> usersInterested;
  final String description;
  final String location;
  final String linkReference;
  final int durationInWeeks;
  final String title;
  final String remuneration;
  final int id;

  JobOffer({@required this.userAuthor,
            @required this.usersInterested,
            @required this.title,
            @required this.description,
            @required this.location,
            @required this.linkReference,
            @required this.durationInWeeks,
            @required this.remuneration,
            @required this.id});

  factory JobOffer.fromJson(Map<String, dynamic> JobOfferJson) {
    return JobOffer(
      userAuthor: JobOfferJson['userAuthor'],
      usersInterested: JobOfferJson['usersInterested'],
      description: JobOfferJson['description'],
      location: JobOfferJson['location'],
      linkReference: JobOfferJson['linkReference'],
      durationInWeeks: JobOfferJson['durationInWeeks'],
      title: JobOfferJson['title'],
      remuneration: JobOfferJson['remuneration'],
      id: JobOfferJson['id'],
    );
  }

  bool userApplied(String username) {
    return this.usersInterested.contains(username);
  }
}