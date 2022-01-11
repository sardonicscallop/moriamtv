import 'package:flutter/material.dart';


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
                })
            ],
          )
      ),
      body: Center(
          child: Text("Home")
      )
    );
  }
}

