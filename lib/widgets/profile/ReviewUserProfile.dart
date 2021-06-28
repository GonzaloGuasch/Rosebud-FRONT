import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ReviewUserProfile extends StatefulWidget {
  final Map<String, dynamic> reviewValue;
  ReviewUserProfile(this.reviewValue);

  @override
  _ReviewUserProfileState createState() => _ReviewUserProfileState();
}

class _ReviewUserProfileState extends State<ReviewUserProfile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        width: 325,
        height: 100,
        color: Color(0xff45aec4),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.reviewValue["userCreate"]),
            Text(widget.reviewValue["review"], style: TextStyle(color: Colors.white, fontSize: 25))
          ],
        )
      ),
    );
  }
}
