import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/data_model/Disk.dart';
import 'package:rosebud_front/widgets/movie/MovieReviewsFromUser.dart';

import 'DiskDescriptionInfo.dart';
import 'DiskPointReview.dart';
import 'LeaveReviewDisk.dart';

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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xff181b20),
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
              diskDescription: 'A human soldier is sent from 2029 to 1984 to stop an almost indestructible cyborg killing machine, sent from the same year, which has been programmed to execute a young woman whose unborn son is the key to humanitys future salvation.',
            ),
          ),

          Container(
              child: DiskPointReview(
                  diskTitle: this.disk.title,
                  ratingInDisk: this.disk.raiting.toDouble()
              )
          ),
          Container(
              child: LeaveReviewDisk(
                  diskTitle: this.disk.title,
                  storage: widget.storage
              )
          ),
          Container(
            child: MovieReviewsFromUser(
                movieTitle: this.disk.title,
                movieReviews: this.disk.reviews,
                storage: widget.storage
            ),
          )
        ],
      ),
    );
  }
}
