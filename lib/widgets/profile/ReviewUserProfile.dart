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
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: () {
        },
        child: Container(
          width: double.infinity,
          height: 100,
          color: Color(0xff45aec4),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.reviewValue["elementTitle"], style: TextStyle(color: Color(0xffd5f971), fontSize: 23)),
              Text(widget.reviewValue["review"], style: TextStyle(color: Colors.white, fontSize: 25))
            ],
          )
        ),
      ),
    );
  }
}
