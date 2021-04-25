import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/data_model/Movie.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final String movieTitle;
  final Function callbackOnDelete;

  const ReviewCard({Key key, this.review, this.movieTitle, this.callbackOnDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

}