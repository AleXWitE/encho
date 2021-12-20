import 'package:encho/commons/models/provider_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'commons/screens/home_page.dart';
import 'commons/screens/settings_page.dart';

void main() {
  runApp(
      ChangeNotifierProvider<ProviderModel>(
        create: (_) => ProviderModel(),
          child: MyApp()));
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
