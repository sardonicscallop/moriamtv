import 'package:shared_preferences/shared_preferences.dart';

void setDefaultSettings() async
{
  SharedPreferences settings = await SharedPreferences.getInstance();

  settings.setBool("homescreen_timetable_show", false);
  settings.setBool("homescreen_recent_show", true);
  settings.setInt("appearance_darktheme", 0);
  settings.setString("appearance_language", "default");

}

class RecentEntities {
  List<Map<String, int>>? data;
  RecentEntities({this.data});

  get() async {
    // SharedPreferences settings = await SharedPreferences.getInstance();
    // List<String> encoded = settings.getStringList("recent_list")!;

    //
    
  }

  update() {

  }
}