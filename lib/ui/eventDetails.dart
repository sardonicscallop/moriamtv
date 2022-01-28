import 'package:flutter/material.dart';
import 'package:moriamtv/data/standaloneEvent.dart' as StandaloneEvent;
import 'package:moriamtv/pickers.dart';

class EventDetails extends StatelessWidget {
  EventDetails({Key? key, required this.event}) : super(key: key);

  final StandaloneEvent.StandaloneEvent event;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          leading: Icon(pickIconForActivityType(event.type.id)),
          title: Text(event.subject.name),
          subtitle: Text(event.type.name, style: TextStyle(fontStyle: FontStyle.italic)),
          // tileColor: Theme.of(context).colorScheme.primary,
          tileColor: pickPrimaryColorForActivity(event.activityId).shade500,
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
        ListTile(
          leading: Icon(Icons.door_front_door),
          title: Text(event.room.name),
        ),
        ListTile(
          leading: Icon(Icons.access_time),
          title: Text(event.startTime.format(context) + " – " + event.endTime.format(context)),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...event.teachers.map((e) => Text(e.name))
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.school),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...event.degrees.map((e) => e.groups > 1
                  ? RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: e.name),
                          TextSpan(
                            style: TextStyle(
                              fontSize: DefaultTextStyle.of(context).style.fontSize! * 0.75,
                              fontStyle: FontStyle.italic
                            ),
                            children: [
                              TextSpan(text: " (group "),
                              TextSpan(text: e.group.toString(),
                                style: TextStyle(
                                    fontSize: DefaultTextStyle.of(context).style.fontSize,
                                    fontStyle: FontStyle.normal
                                )
                              ),
                              TextSpan(text: "/" + e.groups.toString() + ")")
                            ]
                          )
                        ]
                      )
                    )
                  : Text(e.name)
              ),
            ],
          )
        ),
        ListTile(
          leading: Icon(Icons.timer),
          title: Text(event.length.inMinutes.toString() + " min (plus " + event.breakLength.inMinutes.toString() + " min of break)"),
        )
      ],
    );
  }
}