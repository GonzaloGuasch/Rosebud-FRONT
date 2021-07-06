import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/data_model/Disk.dart';
import 'package:rosebud_front/data_model/Movie.dart';
import 'package:rosebud_front/widgets/disk/DiskDetail.dart';
import 'package:rosebud_front/widgets/movie/MovieDetail.dart';



class ElementCard extends StatelessWidget {
  final ElementObject element;
  final LocalStorage storage;
  final bool isMoveCard;

  const ElementCard({Key key, this.element, this.storage, this.isMoveCard}) : super(key: key);

  Widget makeCard() {
    if(isMoveCard) {
      Movie movie = this.element as Movie;
      return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(image: movie.movieImage.image, width: 80),
            Text(movie.title, style: TextStyle(color: Color(0xffd5f971), fontSize: 30))
          ]
      );
    } else {
      Disk disk = this.element as Disk;
      return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(image: disk.diskImage.image, width: 80),
            Text(disk.title, style: TextStyle(color: Color(0xffd5f971), fontSize: 30)),
          ]
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => this.isMoveCard ? MovieDetail(this.element, this.storage) : DiskDetail(this.element as Disk, this.storage)),
          );
        },
        child:
        Container(
          margin: const EdgeInsets.all(2.0),
          padding: const EdgeInsets.all(3.0),
          height: 140.0,
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xff33363b)),
              )
          ),
          child: this.makeCard()
        )
    );
  }
}