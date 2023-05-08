import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '/networking.dart';
import '/data/models.dart' as Models;
import '/data/standaloneEvent.dart';
import '/ui/eventCard.dart';
import '/ui/timetableScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text("Drawer header")),
            ListTile(
                title: const Text("Home"), leading: const Icon(Icons.home)),
            ListTile(
                title: const Text("Search"),
                leading: const Icon(Icons.search),
                onTap: () {
                  Navigator.pushNamed(context, '/searchScreen');
                }),
            ListTile(
                title: const Text("Mockup table"),
                leading: const Icon(Icons.table_chart_outlined),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TimetableScreen(
                              entity: Models.SearchResult(
                                  id: 0,
                                  name: "MOCKUP",
                                  entityType: Models.EntityType.degree),
                              useMockup: true)));
                }),
            ListTile(
                title: const Text("Export to calendar"),
                leading: const Icon(MdiIcons.databaseExport),
                onTap: () {
                  // Navigator.pushNamed(context, '/exportScreen');
                }
            ),
            ListTile(
              title: const Text("Settings"),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.pushNamed(context, '/settingsScreen');
              }
            ),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                if (snapshot.hasData) {
                  final PackageInfo packageInfo = snapshot.data!;
                  return AboutListTile(
                    icon: const Icon(Icons.info),
                    applicationIcon: const FlutterLogo(),
                    applicationName: packageInfo.appName,
                    applicationVersion: packageInfo.version,
                    applicationLegalese: "© K. Kołodziejak",
                    aboutBoxChildren: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyText2!,
                            text: "Mobile client for Moria timetabling system of Marie Curie University in Lublin. Official web client is available at "
                          ),
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyText2!
                                  .copyWith(color: Theme.of(context).colorScheme.primary),
                            text: "moria.umcs.lublin.pl",
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () { launch("https://moria.umcs.lublin.pl"); }
                          ),
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyText2!,
                            text: ". Check more about this app on "),
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyText2!
                                .copyWith(color: Theme.of(context).colorScheme.primary),
                            text: "github",
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () { launch("https://github.com/sardonicscallop/moriamtv/"); }
                          ),
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyText2!,
                            text: ". If you have noticed any bugs, please report them to "
                          ),
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyText2!
                                .copyWith(color: Theme.of(context).colorScheme.primary),
                            text: "my email",
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () { launch("mailto:kkolodziejak@o2.pl"); }
                          ),
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyText2!,
                            text: " or create an issue on GitHub."
                          ),
                        ]),
                      )
                    ],
                  );
                } else {
                  return ListTile();
                }
              })
          ],
        )
      ),
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot<SharedPreferences> settingsSnapshot) { /*
            if (settingsSnapshot.hasError) {
              print(settingsSnapshot.toString());
              return Center(
                child: Text('Error: ' + settingsSnapshot.error.toString()),
              );
            } else if (settingsSnapshot.hasData) { */
              //if(settingsSnapshot.data!.getBool("homescreen_timetable_show")!)
              return FutureBuilder(
                future: getMockup(),
                builder: (BuildContext context, AsyncSnapshot<List<Models.Activity>> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.toString());
                    return Center(
                      child: Text('Error: ' + snapshot.error.toString()),
                    );
                  } else if (snapshot.hasData) {

                    List<Models.Activity> activities = snapshot.data!;
                    List<List<StandaloneEvent>> eventsByWeekdays = getStandaloneEventsTable(activities);
                    const double horizontalPadding = 15.0;
                    const double verticalPadding = 5.0;
                    const double eventCardHeight = 150.0;

                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 100.0,
                          flexibleSpace: FlexibleSpaceBar(
                            title: RichText(
                                text: TextSpan(
                                  // style: ,
                                    children: [
                                      TextSpan(
                                        // style:,
                                          text: "Your plan "),
                                      TextSpan(
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                          text: "for today"),
                                    ])),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: horizontalPadding),
                          sliver: SliverToBoxAdapter(
                            child: SizedBox(
                              child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        style: Theme.of(context).textTheme.button!,
                                        text: "for ".toUpperCase()
                                    ),
                                    TextSpan(
                                        style: Theme.of(context).textTheme.button!
                                            .copyWith(color: Theme.of(context).colorScheme.primary),
                                        text: "1 Fizyka I st. stac.".toUpperCase()
                                    )
                                  ])
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: horizontalPadding),
                          sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: verticalPadding),
                                    child: SizedBox(
                                        child: Text("In x minutes:")
                                    )
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: verticalPadding),
                                    child: SizedBox(
                                        height: eventCardHeight,
                                        child: EventCard(
                                            event: eventsByWeekdays[1].first,
                                            showTime: true
                                        )
                                    )
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: verticalPadding),
                                    child: SizedBox(child: Text("Following:"))),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: verticalPadding),
                                    child: SizedBox(
                                        height: eventCardHeight,
                                        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constrains) {
                                          return ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              ...eventsByWeekdays[2].map((e) => SizedBox(
                                                  width: constrains.maxWidth * 0.75,
                                                  child: EventCard(event: e, showTime: true)
                                              ))
                                            ],
                                          );
                                        })
                                    )
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: verticalPadding),
                                    child: Row(children: [
                                      Text("Last updated: Monday, 2023-03-29 21:37"),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.refresh, color: Theme.of(context).primaryIconTheme.color),
                                          tooltip: "Refresh"
                                      ),
                                      Spacer(),
                                      TextButton(
                                          onPressed: () {},
                                          child: Text("See more".toUpperCase())
                                      )
                                    ])
                                ),
                              ])
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: horizontalPadding,
                                  vertical: verticalPadding
                              ),
                              child: Text("Last viewed entities: "),
                            )
                          ]),
                        ),
                        SliverPadding(
                            padding: const EdgeInsets.symmetric(
                                vertical: verticalPadding),
                            sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text("Gorgol Marek, dr"),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text("Matyjasek Jerzy, dr. hab."),
                                  ),
                                  ListTile(
                                    leading: Icon(MdiIcons.door),
                                    title: Text("F1 (bud. B półpiętro)"),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.school),
                                    title: Text("1 Fizyka I stopień stacjonarny"),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.school),
                                    title: Text("2 Mat w Fin dz uz (akt)"),
                                  )
                                ])
                            )
                        )

                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            /*} else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } */
          },
          ));
        }
}