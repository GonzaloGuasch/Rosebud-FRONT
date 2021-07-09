import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/widgets/facade/ElementSearcher.dart';



class HomeChoice extends StatefulWidget {
  final LocalStorage storage;
  HomeChoice(this.storage);

  @override
  _HomeChoiceState createState() => _HomeChoiceState();
}

class _HomeChoiceState extends State<HomeChoice> {


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context,
          <String>[
            "feature1",
            "feature2"
          ]
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1a1414),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("ROSEBUD APP", style: TextStyle(color: Color(0xffd5f971), fontSize: 30, fontWeight: FontWeight.w600)),
                DescribedFeatureOverlay(
                  featureId: 'feature1',
                  targetColor: Colors.white,
                  textColor: Colors.black,
                  backgroundColor: Colors.green.shade400,
                  contentLocation: ContentLocation.trivial,
                  title: Text("Elegí la categoria", style: TextStyle(fontSize: 25)),
                  pulseDuration: Duration(seconds: 1),
                  enablePulsingAnimation: true,
                  barrierDismissible: false,
                  overflowMode: OverflowMode.wrapBackground,
                  openDuration: Duration(seconds: 1),
                  description: Text("Podes buscar una película y guardarla en tu lista", style: TextStyle(fontSize: 20)),
                  tapTarget: Icon(Icons.movie),
                  child: ButtonHome(widget.storage, "Movie section", true, "Peliculas", Icon(Ionicons.md_film, size: 120))),
                DescribedFeatureOverlay(
                    featureId: 'feature2',
                    targetColor: Colors.white,
                    textColor: Colors.black,
                    backgroundColor: Colors.red.shade300,
                    contentLocation: ContentLocation.trivial,
                    title: Text("También hay música!", style: TextStyle(fontSize: 25)),
                    pulseDuration: Duration(seconds: 1),
                    enablePulsingAnimation: true,
                    barrierDismissible: false,
                    overflowMode: OverflowMode.wrapBackground,
                    openDuration: Duration(seconds: 1),
                    description: Text("¿Escuchaste un disco y queres guardarlo?", style: TextStyle(fontSize: 20)),
                    tapTarget: Icon(Icons.music_note),
                    child: ButtonHome(widget.storage, "Music section", false, "Discos", Icon(Ionicons.md_musical_notes, size: 100)))
            ],
            ),
          )
      ),
    );
  }
}


class ButtonHome extends StatelessWidget {
  final LocalStorage storage;
  final String section;
  final bool isMovieCategory;
  final String category;
  final Icon icon;
  ButtonHome(this.storage, this.section, this.isMovieCategory, this.category, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, top: 50, right: 30, bottom: 10),
      height: 200,
      width: 200,
      child:IconButton(
        icon: this.icon,
        tooltip: this.section,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ElementSearcher(this.storage, this.isMovieCategory, this.category)),
          );
        },
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
