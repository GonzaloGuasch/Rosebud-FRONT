import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/data_model/Disk.dart';
import 'package:rosebud_front/widgets/movie/MovieReviewsFromUser.dart';
import 'package:rosebud_front/widgets/review/LeaveReview.dart';

import 'DiskDescriptionInfo.dart';
import 'DiskPointReview.dart';

class DiskDetail extends StatefulWidget {
  final Disk disk;
  final LocalStorage storage;
  DiskDetail(this.disk, this.storage);

  @override
  _DiskDetailState createState() => _DiskDetailState(disk);
}

class _DiskDetailState extends State<DiskDetail> {
  Disk disk;
  _DiskDetailState(this.disk);

  void callback(context) {
    setState(() {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DiskDetail(widget.disk, widget.storage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xff1a1414),
      child: ListView(
        children: [
          Container(
              child: DescribedFeatureOverlay(
                  featureId: 'adddMovie',
                  targetColor: Colors.white,
                  textColor: Colors.black,
                  backgroundColor: Colors.green.shade400,
                  contentLocation: ContentLocation.trivial,
                  title: Text('Info de la peli', style: TextStyle(fontSize: 20.0)),
                  pulseDuration: Duration(seconds: 1),
                  enablePulsingAnimation: true,
                  barrierDismissible: false,
                  overflowMode: OverflowMode.wrapBackground,
                  openDuration: Duration(seconds: 1),
                  description: Text('Agrega la peli a tu lista de vistas, deja tu puntuación si te gusto y lee las reviews de otrxs usuarixs!'),
                  tapTarget: Icon(Icons.movie),
                  child: Image(image: this.disk.diskImage.image)
              )),
          Container(
            child: DiskDescriptionInfo(
              storage: widget.storage,
              diskTitle: this.disk.title,
              diskBand: this.disk.band,
              diskDescription: this.disk.description,
              diskYear: this.disk.year

            ),
          ),

          Container(
              child: DiskPointReview(
                  diskTitle: this.disk.title,
                  ratingInDisk: this.disk.raiting.toDouble()
              )
          ),
          Container(
              child: LeaveReview(
                  ttile: this.disk.title,
                  category: 'disk',
                  storage: widget.storage,
                  callback: this.callback
              )
          ),
          Container(
            child: ReviewsFromUser(
                movieTitle: this.disk.title,
                storage: widget.storage,
                category: 'disk',
            ),
          )
        ],
      ),
    );
  }
}
