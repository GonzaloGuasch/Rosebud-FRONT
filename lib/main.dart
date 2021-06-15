import 'package:flutter/material.dart';
import 'widgets/NavigationBar.dart';
import 'package:feature_discovery/feature_discovery.dart';

void main() {
  runApp(RosebudApp());
}

class RosebudApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
        recordStepsInSharedPreferences: false,
        child: MaterialApp(
          home: NavigationBar()
        )
      );
    }
}








