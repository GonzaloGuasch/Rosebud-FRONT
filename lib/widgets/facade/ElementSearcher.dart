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
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xffd5f971)),
          backgroundColor: Color(0xff1a1414),
          title: Text("BUSCADOR DE ${widget.categoryName.toUpperCase()}", style: TextStyle(color: Color(0xffd5f971))),
        ),
        body: Container(
            color: Color(0xff1a1414),
            child: ListView(
              children: [
                TextField(
                  key: Key('ElementInputSearch'),
                  style: TextStyle(color: Color(0xffd5f971)),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    makeSearch(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Titulo de la ${widget.categoryName}',
                    hintStyle: TextStyle(fontSize: 20.0, color: Color(0xffec1fa2)),
                  ),
                ),
                this.createAllResults()
              ],
            )
        )
    );
  }
}
