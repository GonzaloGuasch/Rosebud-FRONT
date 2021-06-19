import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/data_model/Movie.dart';
import 'package:rosebud_front/utils/DiskUtil.dart';
import 'package:rosebud_front/utils/MovieUtils.dart';


class ElementSearcher extends StatefulWidget {
  final LocalStorage storage;
  final bool isMovieElement;
  final String categoryName;
  ElementSearcher(this.storage, this.isMovieElement, this.categoryName);

  @override
  _ElementSearcherState createState() => _ElementSearcherState();
}

class _ElementSearcherState extends State<ElementSearcher> {
  List<ElementObject> elementsResult = [];

  Future<void> makeSearch(String elementName) async {
    if(widget.isMovieElement) {
       List<ElementObject> movies = await MovieUtil.makeMovieResult(elementName);
       setState(()  {
         elementsResult = movies;
       });
    } else {
        List disks = await DiskUtil.makeDiskResult(elementName);
        setState(()  {
          elementsResult = disks;
        });
    }
  }

  Widget createAllResults() {
    if(widget.isMovieElement) {
      return MovieUtil.createAllResults(this.elementsResult, widget.storage);
    }
    return DiskUtil.createAllResults(this.elementsResult, widget.storage);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff445565),
        appBar: AppBar(
          backgroundColor: Color(0xff334454),
          title: Text("BUSCADOR DE ${widget.categoryName.toUpperCase()}"),
        ),
        body: Container(
            color: Color(0xff334454),
            child: Column(
              children: [
                TextField(
                  key: Key('ElementInputSearch'),
                  style: TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    makeSearch(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Titulo de la ${widget.categoryName}',
                  ),
                ),
                this.createAllResults()
              ],
            )
        )
    );
  }
}
