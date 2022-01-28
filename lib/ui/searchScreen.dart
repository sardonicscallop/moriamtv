import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moriamtv/ui/timetableScreen.dart';

import '/networking.dart';

class SearchWithinCheckbox extends StatelessWidget {
  const SearchWithinCheckbox({
    Key? key,
    required this.title,
    required this.padding,
    required this.value,
    required this.onChanged,
    this.checkColor,
    this.fillColor,
  }) : super(key: key);


  final Widget title;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? checkColor;
  final MaterialStateProperty<Color>? fillColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Checkbox(
                  value: value,
                  onChanged: (bool? newValue) {
                    onChanged(newValue!);
                  },
                  checkColor: checkColor,
                  fillColor: fillColor,
                ),
                title,
              ],
            )
          ],
        )

      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final searchBoxController = TextEditingController();

  bool _searchDegrees = true;
  bool _searchTeachers = true;
  bool _searchRooms = true;


  @override
  void initState() {
    super.initState();
    searchBoxController.addListener(_showSearchResults);
  }

  @override
  void dispose() {
    searchBoxController.dispose();
    super.dispose();
  }

  void _showSearchResults() {
    // todo sth there
    print(searchBoxController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: searchBoxController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(Icons.search, color: Colors.white),
              enabledBorder: InputBorder.none,
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusColor: Colors.white,
              ),
            ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: Row(
              /*scrollDirection: Axis.horizontal,
              shrinkWrap: true, */
              children: [
                SearchWithinCheckbox(
                  value: _searchDegrees,
                  onChanged: (bool? value) {
                    setState(() {
                      _searchDegrees = value!;
                    });
                    },
                  title: Text("Degrees", style: TextStyle(color: Colors.white)),
                  padding: const EdgeInsets.all(5.0),
                  fillColor: MaterialStateProperty.all(Colors.white),
                  checkColor: Colors.blue,
                ),
                SearchWithinCheckbox(
                  value: _searchTeachers,
                  onChanged: (bool? value) {
                    setState(() {
                      _searchTeachers = value!;
                    });
                  },
                  title: Text("Teachers", style: TextStyle(color: Colors.white)),
                  padding: const EdgeInsets.all(5.0),
                  fillColor: MaterialStateProperty.all(Colors.white),
                  checkColor: Colors.blue,
                ),
                SearchWithinCheckbox(
                  value: _searchRooms,
                  onChanged: (bool? value) {
                    setState(() {
                      _searchRooms = value!;
                    });
                  },
                  title: Text("Rooms", style: TextStyle(color: Colors.white)),
                  padding: const EdgeInsets.all(5.0),
                  fillColor: MaterialStateProperty.all(Colors.white),
                  checkColor: Colors.blue,
                ),
              ]
            )
          )
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
                return SearchResultList(results: snapshot.data!);
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
        );
      },
    );
  }
}