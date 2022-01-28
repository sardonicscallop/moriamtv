import 'package:flutter/material.dart';
import 'timetableScreen.dart';
import '../data/models.dart' as Models;


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text("Drawer header")
              ),
              ListTile(
                title: const Text("Home"),
                leading: const Icon(Icons.home)
              ),
              ListTile(
                title: const Text("Search"),
                leading: const Icon(Icons.search),
                onTap: () {
                  Navigator.pushNamed(context, '/searchScreen');
                }
              ),
              ListTile(
                  title: const Text("Mockup table"),
                  leading: const Icon(Icons.table_chart_outlined),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)
                            => TimetableScreen(
                              entity: Models.SearchResult(id: 0, name: "MOCKUP", entityType: Models.EntityType.degree),
                              useMockup: true))
                    );
                  }
              ),
              ListTile(
                title: const Text("Settings"),
                leading: const Icon(Icons.settings),
              ),
              ListTile(
                title: const Text("About"),
                leading: const Icon(Icons.info),
              )
            ],
          )
      ),
      body: Center(
          child: Text("Home")
      )
    );
  }
}

