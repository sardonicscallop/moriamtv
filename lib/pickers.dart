import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/*
class MaterialColorPicker {
  MaterialColorPicker();

  final List<MaterialColor> colorPalette = Colors.primaries;
  List<bool> isColorTaken = [ for(int x = 0; x < Colors.primaries.length; x++) false ];

  MaterialColor pickColorForActivity(int activityId) {
    int colorId = activityId % Colors.primaries.length;

    if(isColorTaken[colorId])
    {
      bool resolved = false;
      for (int x = 0; x < Colors.primaries.length; x++)
        if (!isColorTaken[x])
        {
          colorId = x;
          resolved = true;
        }
      if(!resolved)
        for (int x = 0; x < Colors.primaries.length; x++)
          isColorTaken[x] = false;
    }
    isColorTaken[colorId] = true;
    return Colors.primaries[colorId];
  }
}


 */

MaterialColor pickPrimaryColorForActivity(int activityId) {
  int colorId = activityId % Colors.primaries.length;
  if(Colors.primaries[colorId] == Colors.yellow)
    colorId++;
  return Colors.primaries[colorId];
}

MaterialColor pickPrimaryColorForEntity(int entityId) {
  int colorId = entityId % Colors.primaries.length;
  if(Colors.primaries[colorId] == Colors.yellow)
    colorId++;
  return Colors.primaries[colorId];
}

IconData pickIconForActivityType (int typeId) {
  final List<IconData> icons = [
    Icons.arrow_forward,    // default
    Icons.menu_book,        // wykład
    MdiIcons.radioactive,   // laboratorium
    MdiIcons.leadPencil,    // konwersatorium
    MdiIcons.setSquare,     // ćwiczenia
    Icons.forum,            // seminarium
  ];
  if(typeId > icons.length - 1)
    return icons[0];
  else
    return icons[typeId];
}