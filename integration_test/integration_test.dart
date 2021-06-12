import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rosebud_front/main.dart' as app;

void main() {
  group('App test', (){
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      testWidgets("Recorro la navigation bar", (tester) async {
        app.main();
        await tester.pumpAndSettle();


        final MovieIcon = find.byKey(Key('MovieButton')).first;
        await tester.tap(MovieIcon);
        await tester.pumpAndSettle();
        
        final inputSearch = find.byKey(Key('ElementInputSearch')).first;
        
        await tester.enterText(inputSearch, 'Movie title');
        await tester.pumpAndSettle();
      });
  });
}