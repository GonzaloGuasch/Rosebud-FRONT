import 'package:flutter/material.dart';
import 'package:rosebud_front/widgets/movie/movie_container.dart';

import 'widgets/NavigationBar.dart';

void main() {
  runApp(RosebudApp());
}

class RosebudApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NavigationBar(),
    );
  }
}

class HomeChoice extends StatefulWidget {
  @override
  _HomeChoiceState createState() => _HomeChoiceState();
}

class _HomeChoiceState extends State<HomeChoice> {

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
                  IconButton(
                    icon: Icon(Icons.movie, size: 50),
                    tooltip: 'Movie section',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MovieContainer()),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.music_note, size: 50),
                    tooltip: 'Music section',
                    onPressed: () {
                    },
                  ),
                ],
              )
         ),
    );
  }
}






