import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moriamtv/ui/timetableScreen.dart';

import '/networking.dart';
import 'package:moriamtv/data/models.dart' as Models;


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchBoxController = new TextEditingController();
  String filter = "";
  List<SearchResultCategory> resultsList = [];

  @override
  void initState() {
    super.initState();

    searchBoxController.addListener(() {
        setState(() {
          filter = searchBoxController.text;
        });
    });
  }

  @override
  void dispose() {
    searchBoxController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: TextField(
            controller: searchBoxController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(Icons.search, color: Colors.white),
              suffixIcon:
                InkWell(
                  child: Icon(Icons.clear, color: Colors.white),
                  onTap: () { searchBoxController.text = ""; }
                ),
              enabledBorder: InputBorder.none,
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusColor: Colors.white,
              ),
            ),
        ),
        body:
          FutureBuilder<List<SearchResultCategory>>(
            future: fetchSearchResults(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.toString());
                return Center(
                  child: Text('Error: ' + snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                resultsList = snapshot.data!;
                if((filter.isNotEmpty)) {
                  for (SearchResultCategory x in resultsList) {
                    List<Models.SearchResult> toRemove = [];
                    for (Models.SearchResult y in x.items)
                      if (!y.name.toLowerCase().contains(filter.toLowerCase()))
                        toRemove.add(y);
                    x.items.removeWhere((element) => toRemove.contains(element));
                  }
                }
                return SearchResultList(results: resultsList);
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

class SearchResultList extends StatefulWidget {
  const SearchResultList({Key? key, required this.results}) : super(key: key);

  final List<SearchResultCategory> results;

  @override
  _SearchResultListState createState() => _SearchResultListState();
}

class _SearchResultListState extends State<SearchResultList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.results.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text(widget.results[index].name),
          children: <Widget>[
            ...widget.results[index].items.map(
                    (result) => ListTile(
                        title: Text(result.name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TimetableScreen(entity: result))
                          );
                        }
                    )
            )
          ],
          initiallyExpanded: true,
        );
      },
    );
  }
}