import 'package:flutter/material.dart';
import 'widgets/NavigationBar.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:localstorage/localstorage.dart';

void main() {
  runApp(RosebudApp());
}

class RosebudApp extends StatelessWidget {
  final LocalStorage storage = new LocalStorage("username");

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
        recordStepsInSharedPreferences: false,
        child: MaterialApp(
          home: NavigationBar(storage)
        )
      );
    }
}








