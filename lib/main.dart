import 'package:flutter/material.dart';

import 'ui/homeScreen.dart';
import 'ui/searchScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'moriamtv';

    return MaterialApp(
      title: appTitle,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(title: appTitle),
        '/searchScreen': (context) => const SearchScreen()
      }
    );
  }
}
