import 'package:flutter/cupertino.dart';

class DataProfile extends StatelessWidget {
 final String amount;
 final String category;
 const DataProfile(this.amount, this.category, {Key key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(this.amount, style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)),
        Text(this.category, style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold))
      ],
    );
  }
}

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DataProfile('1', 'vistas'),
            DataProfile('0', 'seguidores'),
            DataProfile('0', 'seguidos'),
          ],
        ),
      ),
    );
  }
}
