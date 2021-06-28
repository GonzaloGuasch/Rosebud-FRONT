import 'dart:convert';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/data_model/UserData.dart';
import 'package:rosebud_front/widgets/profile/userFollow.dart';
import 'package:rosebud_front/widgets/user/LoginUser.dart';
import 'package:rosebud_front/widgets/user/RegisterUser.dart';
import 'StatsUser.dart';

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
  final LocalStorage storage;
  final Function callback;
  const DataProfileGesture(this.username, this.amount, this.category, this.isFollowersOfUsers, this.storage, this.callback, {Key key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserFollow(this.username, this.isFollowersOfUsers, this.storage, this.callback)),
          );
        },
        child: Column(
          children: [
              Text(this.amount, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xffd5f971))),
              Text(this.category, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xffd5f971)))
          ],
        )
    );
  }
}

class DataRow extends StatefulWidget {
  final LocalStorage storage;
  DataRow(this.storage);

  @override
  _DataRowState createState() => _DataRowState();
}

class _DataRowState extends State<DataRow> {
  int data;

  void callbackButtonAction() {
    setState(() {});
  }

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
    String username = widget.storage.getItem('username')['username'];
    final _userData = await http.get(Uri.http(BACKEND_PATH_LOCAL, 'user/info/${username}' ));
    return _userData.body;
  }


  @override
  Widget build(BuildContext context) {
    final _value = this.userDataAsync();
   String username = widget.storage.getItem('username')['username'];
    return SizedBox(
      child: FutureBuilder<String>(
          future: _value,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              var userData = UserData.fromJson(jsonDecode(snapshot.data));
              children = [
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
                  child:DataProfileGesture(username, userData.followers.toString(), 'seguidores', true, widget.storage, this.callbackButtonAction)),
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
                child: DataProfileGesture(username, userData.following.toString(), 'seguidos', false, widget.storage, this.callbackButtonAction)),
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
  final LocalStorage storage;
  UserProfile(this.storage);

  @override
  Widget build(BuildContext context) {
    return this.storage.getItem('username') != null ?
    Scaffold(
      backgroundColor: Color(0xff1a1414),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DataRow(storage),
            StatsUser(storage: storage,
                      message: "DIRECTORES MAS VISTOS",
                      category: 'movie'),
            StatsUser(storage: storage,
                      message: "BANDAS MAS ESCUCHADAS",
                      category: 'disk')
          ],
        ),
      ),
    ) : RegisterUserProfile(storage);
  }
}


class RegisterUserProfile extends StatelessWidget {
  final LocalStorage storage;
  RegisterUserProfile(this.storage);

  @override
  Widget build(BuildContext context) {
    void callback() {
       Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Inicia sesion/registrate'),
                     backgroundColor: Color(0xff0017ff)),
      backgroundColor: Color(0xff16086c),
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Container(
            child: Column(
              children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 13),
                    child: Text('Primero es necesario que te registres o logees ',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500)),
                  ),
                SizedBox(
                  width: 280,
                  height: 50,
                  child:TextButton(
                          style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xfffdd94d)),
                                  foregroundColor: MaterialStateProperty.all<Color>(Color(0xff806d27))),
                          child: Text('Login', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginUser(this.storage, callback)),
                            );
                          },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: 280,
                    height: 50,
                    child:TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff81dfc5)),
                          foregroundColor: MaterialStateProperty.all<Color>(Color(0xff3c826e))),
                      child: Text('Register', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterUser(this.storage, callback)),
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
        ),
      )
    );
  }
}



