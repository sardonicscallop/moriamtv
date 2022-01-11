import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models.dart' as Models;
import 'networking.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'moriamtv';

    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Models.Degree>>(
        future: fetchDegrees(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.toString());
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return DegreesList(degrees: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class DegreesList extends StatelessWidget {
  const DegreesList({Key? key, required this.degrees}) : super(key: key);

  final List<Models.Degree> degrees;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: degrees.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(degrees[index].name)
        );
      },
    );
  }
}