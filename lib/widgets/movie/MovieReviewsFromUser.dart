import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/data_model/Movie.dart';
import 'package:rosebud_front/widgets/review/ReviewCard.dart';
import 'package:http/http.dart' as http;

class ReviewsFromUser extends StatefulWidget {
  final String movieTitle;
  final LocalStorage storage;
  final String category;
  const ReviewsFromUser({Key key, this.movieTitle, this.storage, this.category}) : super(key: key);

  @override
  _ReviewsFromUserState createState() => _ReviewsFromUserState();
}

class _ReviewsFromUserState extends State<ReviewsFromUser> {
  List<Widget> reviewsWidget = [];

  @override
  void initState() {
    super.initState();
    this.drawReviews();
  }

  void drawReviews() async {
    final _response = await http.get(Uri.http(BACKEND_PATH_LOCAL, "${widget.category}/reviewsOf/" + widget.movieTitle));
    List reviewsOfMovie = jsonDecode(_response.body);
    List<Review> movieResultList =  List<Review>.from(reviewsOfMovie.map((aReviewJSON) => Review.fromJson(aReviewJSON)));
    List<Widget> reviews = [];
    for(int i = 0; i < movieResultList.length; i++) {
          reviews.add(
            ReviewCard(
              storage: widget.storage,
              userCreate: movieResultList[i].userCreate,
              review: movieResultList[i].review,
              hasSpoilers: movieResultList[i].hasSpoilers,
              id: movieResultList[i].id
            )
          );
    }
    setState(() {
      this.reviewsWidget = reviews;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Container(
              width: 400.0,
              height: 70.0,
              padding: const EdgeInsets.only(top: 15.0),
              decoration: BoxDecoration(
                  border: Border(
                  top: BorderSide(color: Color(0xff33363b)),
                  )
              ),
              child:
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text('REVIEWS', style: TextStyle(fontSize: 28.0, color: Color(0xff9ea7ae))),
                ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: this.reviewsWidget.isEmpty ?
                                [Padding(padding: const EdgeInsets.only(left: 15, bottom: 20),
                                    child: Text("No hay reviews todavia!",
                                              style: TextStyle(fontSize: 28.0, color: Color(0xff9ea7ae))))] :
                                this.reviewsWidget
            )
        ],
      ),
    );
  }
}
