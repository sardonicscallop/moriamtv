import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:moriamtv/ui/eventDetails.dart';

import '/data/models.dart' as Models;
import '/data/modelsActivity.dart' as ActivityModels;
import '/data/standaloneEvent.dart' as StandaloneEvent;
import '/networking.dart';
import '/pickers.dart';


class TimetableScreen extends StatelessWidget {
  final Models.SearchResult entity;
  final bool? useMockup;
  TimetableScreen({Key? key, required this.entity, this.useMockup}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // API: 0 – unplanned, 1 – Monday, ... 7 – Sunday
    // Flutter: 0 – Sunday, 1 – Monday, ..., 6 – Saturday

    initializeDateFormatting("pl_PL", null); // todo: implement localisation
    final unscheduled = "unscheduled";
    final List<String> weekdayNames = [
      unscheduled,
      ...DateFormat.EEEE(/*Localizations.localeOf(context).toLanguageTag()*/"pl_PL").dateSymbols.STANDALONEWEEKDAYS.skip(1),
      DateFormat.EEEE("pl_PL").dateSymbols.STANDALONEWEEKDAYS[0],
    ];

    return DefaultTabController(
      length: weekdayNames.length,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(entity.name),
          backgroundColor: pickPrimaryColorForDegree(entity.id),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border), // todo: implement favorites
              tooltip: "Add to favorites",
              onPressed: () { },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: <Tab>[ // todo: internationalisation
              ...weekdayNames.map((element) => Tab(child: Text(element, style: TextStyle(fontStyle: element == unscheduled ? FontStyle.italic : FontStyle.normal),)))
            ],
          ),
        ),
        body:
          FutureBuilder<List<Models.Activity>>(
            future: useMockup==true ? getMockup() : fetchActivities(http.Client(), entity.entityType, entity.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.toString());
                return Center(
                  child: Text('Error: ' + snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                return TabbedTimetableView(activities: snapshot.data!);
              } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
          ),
      ),
    );
  }
}

class TabbedTimetableView extends StatelessWidget {
  const TabbedTimetableView({Key? key, required this.activities}) : super(key: key);

  final List<Models.Activity> activities;

  @override
  Widget build(BuildContext context) {
    List<List<StandaloneEvent.StandaloneEvent>> eventsByWeekdays = [ for(int k = 0; k < 8; k++) [] ];
    for (Models.Activity activity in activities) {
      for (ActivityModels.Event event in activity.events) {
        eventsByWeekdays[event.weekday].add(
            StandaloneEvent.StandaloneEvent(
                eventId: event.id,
                startTime: event.startTime,
                length: event.length,
                endTime: event.endTime,
                breakLength: event.breakLength,

                activityId: activity.id,
                subject: StandaloneEvent.Subject(
                  id: activity.subjectId, name: activity.subjectName),
                type: activity.type,
                degrees: activity.degrees,
                teachers: activity.teachers,
                room: StandaloneEvent.Room(id: event.roomId, name: event.roomName)
            ));
      }
    }

    return TabBarView(
      children: <Widget>[
        ...eventsByWeekdays.map((e) => WeekdayTab(events: e))
      ],
    );
  }
}


class WeekdayTab extends StatelessWidget {
  WeekdayTab({Key? key, required this.events}) : super(key: key);
  final List<StandaloneEvent.StandaloneEvent> events;
  final double pxPerHour = 70;
  final double rulerWidth = 80;
  final TimeOfDay dayStartTime = TimeOfDay(hour: 08, minute: 00); // both have to be full hours
  final TimeOfDay dayEndTime = TimeOfDay(hour: 20, minute: 00);
  final double topMargin = 25;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: topMargin + (dayEndTime.hour - dayStartTime.hour) * pxPerHour,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Ruler(
                  pxPerHour: pxPerHour,
                  width: rulerWidth,
                  dayStartTime: dayStartTime,
                  dayEndTime: dayEndTime,
                  topMargin: topMargin,
                  expand: true,
                  useDivider: true,
                )
              ),
              Positioned(
                top: topMargin,
                left: rulerWidth,
                width: MediaQuery.of(context).size.width - rulerWidth,
                height: (dayEndTime.hour - dayStartTime.hour) * pxPerHour,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (events.isNotEmpty)
                      ...events.map((e)
                          => EventWidget(
                            event: e,
                            dayStartTime: dayStartTime,
                            width: MediaQuery.of(context).size.width - rulerWidth,
                            pxPerHour: pxPerHour
                          )
                      )
                    else
                      Positioned(
                        child: Center(child: Text("No activities planned for today")),
                        top: 0,
                        width: MediaQuery.of(context).size.width - rulerWidth,
                        height: pxPerHour,
                      )
                  ],
                )
              )
            ],
          )
      )
    );
  }
}


class Ruler extends StatelessWidget {
  Ruler({
    Key? key,
    required this.pxPerHour,
    required this.width,
    required this.dayStartTime,
    required this.dayEndTime,
    this.expand,
    this.useDivider,
    this.topMargin
  }) : super(key: key);

  final double pxPerHour;
  final double width;
  final TimeOfDay dayStartTime;
  final TimeOfDay dayEndTime;
  final bool? expand;
  final bool? useDivider;
  final double? topMargin;
  final double labelPadding = 5.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (expand ?? false) ? MediaQuery.of(context).size.width : width,
      height: (topMargin ?? 0) + (dayEndTime.hour - dayStartTime.hour) * pxPerHour,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              for(int hours = (topMargin ?? 0) > 0 ? -1 : 0; hours < dayEndTime.hour - dayStartTime.hour; hours++)
                Container(
                  height: hours == -1 ? topMargin : pxPerHour,
                  width: (expand ?? false) ? MediaQuery.of(context).size.width : width,
                  decoration: BoxDecoration(
                    color: hours % 2 == 0 ? Colors.white : Colors.grey.shade50,
                    border: (useDivider ?? false) ? Border(bottom: BorderSide(color: Theme.of(context).dividerColor)) : null,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: width,
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: labelPadding, horizontal: 0.0),
                      child: Text(
                        TimeOfDay(hour: (topMargin ?? 0) > 0 ? dayStartTime.hour + hours + 1 : dayStartTime.hour + hours, minute: 00).format(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600),
                      )
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}

class EventWidget extends StatelessWidget {
  EventWidget({
    Key? key,
    required this.event,
    required this.dayStartTime,
    required this.width,
    required this.pxPerHour,
  }) : super(key: key);

  final StandaloneEvent.StandaloneEvent event;
  final TimeOfDay dayStartTime;
  final double width;
  final double pxPerHour;

  @override
  Widget build(BuildContext context) {
    final double height =
        ((event.endTime.hour.toDouble() - event.startTime.hour.toDouble())
         + (event.endTime.minute.toDouble() - event.startTime.minute.toDouble()) / 60)
         * pxPerHour;
    final double paddingVertical = 8;
    final double paddingHorizontal = 16;
    final double typeIconSize = (IconTheme.of(context).size ?? 22) * 3;
    final int groupNo = event.degrees.first.group;      // todo: check context degree,
    final int groupsTotal = event.degrees.first.groups; // ←
    final bool isGroup = (groupsTotal > 1) ? true : false; // todo: adjust width according to number of groups

    return Positioned(
      left: width * (0.1 * (groupNo - 1)),
      top: (event.startTime.hour.toDouble() + event.startTime.minute.toDouble() / 60 - dayStartTime.hour) * pxPerHour,
      height: height,
      width: isGroup ? width * (1 - 0.1 * (groupsTotal - 1)) : width,
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: Card(
          color: pickPrimaryColorForActivity(event.activityId).shade100,
          shadowColor: pickPrimaryColorForActivity(event.activityId).shade700,
          child: InkWell(
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
                      height: height,
                      child: Baseline(
                          baseline: height,
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(event.teachers.length > 1)
                            Text("${event.teachers.length} teachers")
                          else
                             ...event.teachers.map((e) => Text(e.name, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                          if(event.degrees.length > 1)
                            Text("${event.degrees.length} degrees")
                          else
                            ...event.degrees.map((e) => Text(e.name, maxLines: 1, overflow: TextOverflow.ellipsis,))
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(paddingHorizontal, 0, 0, paddingVertical),
                        child: Text(event.room.name,
                          style: TextStyle(
                            color: ListTileTheme.of(context).textColor,
                            // fontStyle: FontStyle.italic
                          )
                        ),
                      )
                  ),
              ],
            )
          )
        ),
      )
    );
  }
}
