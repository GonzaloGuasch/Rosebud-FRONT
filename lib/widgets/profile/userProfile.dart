import 'dart:convert';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/data_model/UserData.dart';
import 'package:rosebud_front/widgets/profile/userFollow.dart';
import 'UserStats.dart';

class DataProfile extends StatelessWidget {
 final String amount;
 final String category;
 const DataProfile(this.amount, this.category, {Key key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(this.amount, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        Text(this.category, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))
      ],
    );
  }
}

class DataProfileGesture extends StatelessWidget {
  final String username;
  final String amount;
  final String category;
  final bool isFollowersOfUsers;
  const DataProfileGesture(this.username, this.amount, this.category, this.isFollowersOfUsers, {Key key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserFollow(this.username, this.isFollowersOfUsers)),
          );
        },
        child: Column(
          children: [
              Text(this.amount, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              Text(this.category, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))
          ],
        )
    );
  }
}

class DataRow extends StatefulWidget {
  @override
  _DataRowState createState() => _DataRowState();
}

class _DataRowState extends State<DataRow> {
  int data;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context,
          <String>[
            "vistas",
            "seguidores",
            "seguidos",
          ]
      );
    });
    super.initState();
  }

  Future<String> userDataAsync() async {
    final _userData = await http.get(Uri.http(BACKEND_PATH_LOCAL, "user/info/usuario" ));
    return _userData.body;
  }


  @override
  Widget build(BuildContext context) {
    final _value = this.userDataAsync();
    return SizedBox(
      child: FutureBuilder<String>(
          future: _value,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              var userData = UserData.fromJson(jsonDecode(snapshot.data));
              children = [
                DescribedFeatureOverlay(
                  featureId: 'vistas',
                  targetColor: Colors.white,
                  textColor: Colors.black,
                  backgroundColor: Colors.amber,
                  contentLocation: ContentLocation.trivial,
                  title: Text('Películas vistas', style: TextStyle(fontSize: 20.0)),
                  pulseDuration: Duration(seconds: 1),
                  enablePulsingAnimation: true,
                  barrierDismissible: false,
                  overflowMode: OverflowMode.wrapBackground,
                  openDuration: Duration(seconds: 1),
                  description: Text('Cuando agregues una peli se va a ver reflejado aca!'),
                  tapTarget: Icon(Icons.movie),
                  child: DataProfile(userData.moviesWatched.toString(), 'vistas')),
                DescribedFeatureOverlay(
                  featureId: 'seguidores',
                  targetColor: Colors.white,
                  textColor: Colors.black,
                  backgroundColor: Colors.amber,
                  contentLocation: ContentLocation.trivial,
                  title: Text('tus seguidores', style: TextStyle(fontSize: 20.0)),
                  pulseDuration: Duration(seconds: 1),
                  enablePulsingAnimation: true,
                  barrierDismissible: false,
                  overflowMode: OverflowMode.wrapBackground,
                  openDuration: Duration(seconds: 1),
                  description: Text('Hace click y mira la lista de quien te sigue'),
                  tapTarget: Icon(Icons.person),
                  child:DataProfileGesture('usuario', userData.followers.toString(), 'seguidores', true)),
                DescribedFeatureOverlay(
                featureId: 'seguidos',
                targetColor: Colors.white,
                textColor: Colors.black,
                backgroundColor: Colors.amber,
                contentLocation: ContentLocation.trivial,
                title: Text('A quien seguis', style: TextStyle(fontSize: 20.0)),
                pulseDuration: Duration(seconds: 1),
                enablePulsingAnimation: true,
                barrierDismissible: false,
                overflowMode: OverflowMode.wrapBackground,
                openDuration: Duration(seconds: 1),
                description: Text('Podes ver siempre a los perfiles que estas siguiendo'),
                tapTarget: Icon(Icons.person),
                child: DataProfileGesture('usuario', userData.following.toString(), 'seguidos', false)),
              ];
            } else {
              children = [
                DataProfile('0', 'vistas'),
                DataProfile('0', 'seguidores'),
                DataProfile('0', 'seguidos')
              ];
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: children
            );
          },
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DataRow(),
            UserStats()
          ],
        ),
      ),
    );
  }
}
