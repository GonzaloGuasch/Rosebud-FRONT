import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:rosebud_front/widgets/movie/MovieSearcher.dart';


class HomeChoice extends StatefulWidget {
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
      body: Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("ELEGI LA CATEGORIA",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              DescribedFeatureOverlay(
                featureId: 'feature1',
                targetColor: Colors.white,
                textColor: Colors.black,
                backgroundColor: Colors.red.shade100,
                contentLocation: ContentLocation.trivial,
                title: Text(
                  'Elegí la categoria',
                  style: TextStyle(fontSize: 20.0),
                ),
                pulseDuration: Duration(seconds: 1),
                enablePulsingAnimation: true,
                overflowMode: OverflowMode.extendBackground,
                openDuration: Duration(seconds: 1),
                description: Text('Aca podes buscar \n las películas que ya viste y queres recordar '),
                tapTarget: Icon(Icons.navigation),
                child: IconButton(
                  key: Key('MovieButton'),
                  icon: Icon(Icons.movie, size: 50),
                  tooltip: 'Movie section',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MovieSearcher()),
                    );
                  },
                ),
            ),
          DescribedFeatureOverlay(
            featureId: 'feature2',
            targetColor: Colors.white,
            textColor: Colors.white,
            backgroundColor: Colors.blue,
            contentLocation: ContentLocation.below,
            title: Text(
              'También hay música!',
              style: TextStyle(fontSize: 20.0),
            ),
            pulseDuration: Duration(seconds: 1),
            enablePulsingAnimation: true,
            overflowMode: OverflowMode.clipContent,
            openDuration: Duration(seconds: 1),
            description: Text('Guarda esos discos que escuchas \n una y otra vez!'),
            tapTarget: Icon(Icons.menu),
            child: IconButton(
                  icon: Icon(Icons.music_note, size: 50),
                  tooltip: 'Music section',
                  onPressed: () {

                    },
              ),
          )
        ],
          )
      ),
    );
  }
}