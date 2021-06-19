import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';

class LeaveReviewDisk extends StatefulWidget {
  final String diskTitle;
  final LocalStorage storage;
  const LeaveReviewDisk({this.diskTitle, this.storage});

  @override
  _LeaveReviewDiskState createState() => _LeaveReviewDiskState();
}

class _LeaveReviewDiskState extends State<LeaveReviewDisk> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
