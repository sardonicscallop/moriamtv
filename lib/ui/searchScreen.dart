import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/models.dart' as Models;
import '/networking.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
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