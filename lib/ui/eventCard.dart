import 'package:flutter/material.dart';
import 'package:moriamtv/data/standaloneEvent.dart';

import '../pickers.dart';
import 'eventDetails.dart';

class EventCard extends StatelessWidget {

  final StandaloneEvent event;
  final bool showTeachers;
  final bool showDegrees;
  final bool showRoom;
  final bool showTime;
  final bool useIcons;

  EventCard({
    required this.event,
    this.showTeachers = true,
    this.showDegrees = true,
    this.showRoom = true,
    this.showTime = false,
    this.useIcons = false //to be implemented
  });

  @override
  Widget build(BuildContext context) {
    final double paddingVertical = 8;
    final double paddingHorizontal = 16;
    final double typeIconSize = (IconTheme.of(context).size ?? 22) * 3;

    // degrees can be empty sometimes, so there's a need of implementing this check, analogous to EventPositionedWidget
    final int groupNo = event.degrees.isNotEmpty ? event.degrees.first.group : 1 ;     // todo: check context degree,
    final int groupsTotal = event.degrees.isNotEmpty ? event.degrees.first.groups : 1; // ←
    final bool isGroup = (groupsTotal > 1) ? true : false; // todo: adjust width according to number of groups

    final detailsTextKey = GlobalKey();
    final roomTextKey = GlobalKey();

    return Card(
        color: pickPrimaryColorForActivity(event.activityId).shade100,
        shadowColor: pickPrimaryColorForActivity(event.activityId).shade700,

        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constrains) {
            return InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  showBottomSheet(
                      context: context,
                      builder: (context) {
                        return EventDetails(event: event);
                      });
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                        bottom: typeIconSize * -0.125,
                        left: typeIconSize * -0.25,
                        child: Icon(
                            pickIconForActivityType(event.type.id),
                            size: typeIconSize,
                            color: Colors.white38)
                    ),
                    if(isGroup)
                      Positioned(
                          bottom: 0,
                          right: 0,
                          height: constrains.maxHeight,
                          child: Baseline(
                              baseline: constrains.maxHeight,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(
                                groupNo.toString(),
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: DefaultTextStyle.of(context).style.fontSize! * 5,
                                ),
                              )
                          )
                      ),
                    if(showRoom)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Padding(
                          key: roomTextKey,
                          padding: EdgeInsets.fromLTRB(paddingHorizontal, 0, 0, paddingVertical),
                          child: Text(event.room.name,
                              style: TextStyle(
                                color: ListTileTheme.of(context).textColor,
                                // fontStyle: FontStyle.italic
                              )
                          ),
                        )
                      ),
                    Positioned(
                      child: ListTile(
                        //minVerticalPadding: paddingVertical,
                        //horizontalTitleGap: paddingHorizontal,
                        title: Text(
                          event.subject.name,
                          /*, style: TextStyle(fontWeight: FontWeight.bold)*/
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Visibility(
                          key: detailsTextKey,
                          visible: true, // todo: make it work
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(showTeachers)
                                if(event.teachers.length > 1)
                                  Text("${event.teachers.length} teachers")
                                else if(event.teachers.length < 1)
                                  Text("No assigned teachers")
                                else
                                  ...event.teachers.map((e) => Text(e.name, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                              if(showDegrees)
                                if(event.degrees.length > 1)
                                  Text("${event.degrees.length} degrees")
                                else if(event.degrees.length < 1)
                                  Text("No assigned degrees")
                                else
                                  ...event.degrees.map((e) => Text(e.name, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                              if(showTime)
                                Text("${event.startTime.format(context)} – ${event.endTime.format(context)}")
                            ],
                          )
                        ),
                      ),
                    )
                  ],
                )
            );
          }
        )
    );
  }
}