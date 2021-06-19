import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/data_model/Movie.dart';
import 'package:rosebud_front/widgets/review/ReviewCard.dart';

class MovieReviewsFromUser extends StatefulWidget {
  final List<Review> movieReviews;
  final String movieTitle;
  final  LocalStorage storage;
  const MovieReviewsFromUser({Key key, this.movieTitle, this.movieReviews, this.storage}) : super(key: key);

  @override
  _MovieReviewsFromUserState createState() => _MovieReviewsFromUserState();
}

class _MovieReviewsFromUserState extends State<MovieReviewsFromUser> {
  final List<Widget> reviewsWidget = [];

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < widget.movieReviews.length; i++) {
          this.reviewsWidget.add(
            ReviewCard(
              storage: widget.storage,
              userCreate: widget.movieReviews[i].userCreate,
              review: widget.movieReviews[i].review,
              hasSpoilers: widget.movieReviews[i].hasSpoilers,
              id: widget.movieReviews[i].id
            )
          );
    }
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
                children: this.reviewsWidget
            )
        ],
      ),
    );
  }
}
