import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/data_model/Movie.dart';

class ReviewCard extends StatefulWidget {
  final Review review;
  final String movieTitle;
  final Function callbackOnDelete;

  const ReviewCard({Key key, this.review, this.movieTitle, this.callbackOnDelete}) : super(key: key);

  @override
  _ReviewCardState createState() => _ReviewCardState(this.review, this.review.hasSpoilers, this.movieTitle, this.callbackOnDelete);
}

class _ReviewCardState extends State<ReviewCard> {
  final Review review;
  final String movieTitle;
  final Function callbackOnDelete;
  bool hasSpoilers;

  _ReviewCardState(this.review, this.hasSpoilers, this.movieTitle, this.callbackOnDelete);

  Widget showNormalReview() {
    return Container(
        padding: const EdgeInsets.all(10.0),
        margin: EdgeInsets.only(bottom: 20.0, top: 15.0), height: 130.0, width: 312.0,
        decoration: BoxDecoration(border: Border.all(), color: Colors.white,),
        child: Column(
          children: [
            Text(
              this.review.review,
              style: TextStyle(fontSize: 20),
            ),
            Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 120.0, top: 10.0),
                    child: Text(
                      this.review.userCreate,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 1.0, top: 11.0),
                      child: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          iconSize: 35.0,
                          color: Colors.red,
                          onPressed: () async {
                            final _response = await http.delete(Uri.http(BACKEND_PATH_LOCAL, "review/delete/" + this.movieTitle + '/' + this.review.id.toString()));
                            if(_response.statusCode == 200) {
                              callbackOnDelete();
                            }
                          })
                  )]
            ),
          ],
        )
    );
  }
  Widget showSpoilerWarning() {
    return Container(
        padding: const EdgeInsets.all(10.0),
        margin: EdgeInsets.only(bottom: 20.0, top: 15.0), height: 130.0, width: 312.0,
        decoration: BoxDecoration(border: Border.all(), color: Colors.white,),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.amberAccent,
                      size: 30.0
                    ),
                    Text(
                        "Esta review contiene  spoilers",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    Icon(
                        Icons.warning,
                        color: Colors.amberAccent,
                        size: 30.0
                    ),
                    ]
              ),
            ),
            TextButton(
                child: Text('Mostrar review', style: TextStyle(fontSize: 19.0)),
                onPressed: () {
                  setState(() {
                    this.hasSpoilers = false;
                  });
                }
            )
          ],
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return this.hasSpoilers ? this.showSpoilerWarning() : this.showNormalReview();
  }
}


