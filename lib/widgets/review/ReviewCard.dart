import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rosebud_front/widgets/profile/VisitUserProfile.dart';

class ReviewCard extends StatefulWidget {
  final String userCreate;
  final String review;
  final bool hasSpoilers;
  final int id;

  const ReviewCard({Key key, this.userCreate, this.review, this.hasSpoilers, this.id}) : super(key: key);
  @override
  _ReviewCardState createState() => _ReviewCardState(this.hasSpoilers);
}

class _ReviewCardState extends State<ReviewCard> {
  bool hasSpoilers;

  _ReviewCardState(this.hasSpoilers);

  void showSpoilerReview() {
    setState(() {
      this.hasSpoilers = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          child: this.hasSpoilers ? SpoilerCard(showSpoilerReview) : ReviewDetail(widget.userCreate, widget.review),
    );
  }
}




class SpoilerCard extends StatelessWidget {
  Function showSpoilerReview;

  SpoilerCard(this.showSpoilerReview);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: GestureDetector(
        onTap: () {
           this.showSpoilerReview();
        },
        child: Center(
          child: Container(
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15)),
                    color: Color(0xff2b2a27),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 17.0),
                    child: Text("CONTIENE SPOILER", style: TextStyle(color: Color(0xffaab1b9), fontSize: 18.0)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class ReviewDetail extends StatelessWidget {
  final String userCreate;
  final String review;

  ReviewDetail(this.userCreate, this.review);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VisitUserProfile(this.userCreate))
                  );
                },
                child: Text(this.userCreate, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27.0, color: Color(0xff626c78))),
              )
            ),
            Container(
                width: 400.0,
                height: 70.0,
                padding: const EdgeInsets.only(top: 15.0),
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xff33363b)),
                    )
                ),
                child:
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(this.review, style: TextStyle(color: Color(0xffaab1b9), fontSize: 20.0)),
                )
            ),
          ],
        ),
      ),
    );
  }
}


