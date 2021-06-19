import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DiskPointReview extends StatefulWidget {
  final String diskTitle;
  final double ratingInDisk;
  const DiskPointReview({this.diskTitle, this.ratingInDisk});

  @override
  _DiskPointReviewState createState() => _DiskPointReviewState();
}

class _DiskPointReviewState extends State<DiskPointReview> {

  void rateDisk(rating) {

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: widget.ratingInDisk,
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
                this.rateDisk(rating);
              },
            ),
          ],
        ),
      ),
    );
  }
}
