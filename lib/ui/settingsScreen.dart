import 'package:flutter/material.dart';
import 'package:moriamtv/ui/uiMessageHandler.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body:
      FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.toString());
            return UiMessageHandler(messageText: 'Error: ' + snapshot.error.toString(), messageType: UiMessageType.error);
          } else if (snapshot.hasData) {
            return SettingsList(
              sections: [
                SettingsSection(
                    title: Text("Home screen"),
                    tiles: /*for (var value1 in */[
                      SettingsTile.switchTile(
                        leading: Icon(Icons.home),
                        title: Text("Show timetable for selected entity on home screen"),
                        initialValue: snapshot.data!.getBool('homeScreen_timetable_show') ?? false,
                        onToggle: (x) {  },
                      ),
                      SettingsTile(
                        leading: Icon(Icons.arrow_forward),
                        title: Text("Selected entity"),
                        // todo: on tap open a new window with combobox with all entites that you can search, probably maybe also another one with entitytype to choose, and dynamically add group picker for all subjects that have a group. Probably it would be another screen opened as a popup.
                        // that'll mean that there's also a need to check on home screen load if all of subjects have their group assigned. If not, open picker for each subject. Clear unused group saves.
                      ),
                      SettingsTile(
                        leading: Icon(Icons.refresh),
                        title: Text("Refresh frequency"),
                        value: Text(() {
                          final name = [ "every day", "every 2 days", "every Monday"  ];
                          return name[(snapshot.data!.getInt('homeScreen_timetable_refreshFrequency') ?? 0)];
                        }()),
                      ),
                      SettingsTile.switchTile(
                        leading: Icon(Icons.history),
                        title: Text("Show recently viewed entities"),
                        initialValue: snapshot.data!.getBool('homeScreen_recent_show') ?? true,
                        onToggle: (x) {  },
                      ),
                    ]/*) {

 }*/
                ),
                SettingsSection(
                    title: Text("Appearance"),
                    tiles: [
                      SettingsTile(
                        leading: Icon(Icons.dark_mode),
                        title: Text("Dark theme"),
                        value: Text(() {
                          final name = [ "System default", "Off", "On"  ];
                          return name[(snapshot.data!.getInt('appearance_darkTheme') ?? 0)];
                        }()),
                      ),
                      SettingsTile(
                        leading: Icon(Icons.language),
                        title: Text("Language"),
                        value: Text(
                            snapshot.data!.getString('appearance_language') == "default" || snapshot.data!.getString('appearance_language') == null
                                ? "System default"
                                : snapshot.data!.getString('appearance_language')!
                        )
                      ),
                      SettingsTile.switchTile(
                        leading: Icon(Icons.calendar_view_week),
                        title: Text("Hide free days"),
                        initialValue: snapshot.data!.getBool('appearance_hideFreeDays') ?? false,
                        onToggle: () {} (),
                      )
                    ]

                )
              ],
            );
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