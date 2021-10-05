import 'package:flutter/material.dart';

import 'commons/screens/home_page.dart';
import 'commons/screens/settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'ENcho',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomePage(),
      routes: {
            '/home': (BuildContext context) => HomePage(),
            '/settings': (BuildContext context) => SettingsPage(),
    },
      // )
    );
  }
}
