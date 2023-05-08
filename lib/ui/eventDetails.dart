import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:moriamtv/data/models.dart' as Models;
import 'package:moriamtv/data/modelsActivity.dart' as ModelsActivity;
import 'package:moriamtv/data/standaloneEvent.dart' as StandaloneEvent;
import 'package:moriamtv/pickers.dart';
import 'package:moriamtv/ui/timetableScreen.dart';

Widget getDegreeTextRepresentation(ModelsActivity.Degree degree, BuildContext context)
{
  return degree.groups > 1
      ? RichText(
          text: TextSpan(style: TextStyle(color: Colors.black), children: [
          TextSpan(text: degree.name),
          TextSpan(
              style: TextStyle(
                  fontSize: DefaultTextStyle.of(context).style.fontSize! * 0.75,
                  fontStyle: FontStyle.italic),
              children: [
                TextSpan(text: " (group "),
                TextSpan(
                    text: degree.group.toString(),
                    style: TextStyle(
                        fontSize: DefaultTextStyle.of(context).style.fontSize,
                        fontStyle: FontStyle.normal)),
                TextSpan(text: "/" + degree.groups.toString() + ")")
              ])
        ]))
      : Text(degree.name);
}

class EventDetails extends StatelessWidget {
  EventDetails({Key? key, required this.event}) : super(key: key);

  final StandaloneEvent.StandaloneEvent event;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          minVerticalPadding: 16.0,
          leading: Icon(pickIconForActivityType(event.type.id)),
          title: Text(event.subject.name),
          subtitle: Text(event.type.name,
              style: TextStyle(fontStyle: FontStyle.italic)),
          // tileColor: Theme.of(context).colorScheme.primary,
          tileColor: pickPrimaryColorForActivity(event.activityId).shade500,
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
        // room
        ListTile(
          leading: Icon(MdiIcons.door),
          title: Text(event.room.name),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TimetableScreen(
                        entity: new Models.SearchResult(
                            entityType: Models.EntityType.room,
                            id: event.room.id,
                            name: event.room.name))));
          },
          trailing: Icon(Icons.open_in_new),
        ),
        ListTile(
          leading: Icon(Icons.access_time),
          title: Text(event.startTime.format(context) +
              " – " +
              event.endTime.format(context)),
        ),

        // teachers
        event.teachers.length > 1
            ? ExpansionTile(
                leading: Icon(Icons.person),
                title: Text(event.teachers.length.toString() + " teachers"),
                children: [
                    ...event.teachers.map((e) => ListTile(
                        title: Text(e.name),
                        trailing: Icon(Icons.open_in_new),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TimetableScreen(
                                      entity: new Models.SearchResult(
                                          entityType: Models.EntityType.teacher,
                                          id: e.id,
                                          name: e.name))));
                        }))
                  ])
            : event.teachers.isEmpty
              ? ListTile(
                  leading: Icon(Icons.person),
                  title: Text("No assigned teachers")
                )
              : ListTile(
                  leading: Icon(Icons.person),
                  title: Text(event.teachers.first.name),
                  trailing: Icon(Icons.open_in_new),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TimetableScreen(
                                entity: new Models.SearchResult(
                                    entityType: Models.EntityType.teacher,
                                    id: event.teachers.first.id,
                                    name: event.teachers.first.name))));
                  }),

        // degrees
        event.degrees.length > 1
            ? ExpansionTile(
                leading: Icon(Icons.school),
                title: Text(event.degrees.length.toString() + " degrees"),
                children: [
                    ...event.degrees.map((e) => ListTile(
                        title: getDegreeTextRepresentation(e, context),
                        trailing: Icon(Icons.open_in_new),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TimetableScreen(
                                      entity: new Models.SearchResult(
                                          entityType: Models.EntityType.degree,
                                          id: e.id,
                                          name: e.name))));
                        }))
                  ])
            : event.degrees.isEmpty
              ? ListTile(
                  leading: Icon(Icons.school),
                  title: Text("No assigned degrees")
                )
              : ListTile(
                  leading: Icon(Icons.school),
                  title: getDegreeTextRepresentation(event.degrees.first, context),
                  trailing: Icon(Icons.open_in_new),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TimetableScreen(
                                entity: new Models.SearchResult(
                                    entityType: Models.EntityType.degree,
                                    id: event.degrees.first.id,
                                    name: event.degrees.first.name))));
                  }),

        ListTile(
          leading: Icon(Icons.timer),
          title: Text(event.length.inMinutes.toString() +
              " min (plus " +
              event.breakLength.inMinutes.toString() +
              " min of break)"),
        )
      ],
    );
  }
}
