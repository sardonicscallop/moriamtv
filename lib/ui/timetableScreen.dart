import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '/data/models.dart' as Models;
import '/data/standaloneEvent.dart' as StandaloneEvent;
import '/networking.dart';
import '/pickers.dart';
import '/ui/eventCard.dart';
import '/ui/uiMessageHandler.dart';


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
    List<String> weekdayNames = [
      unscheduled,
      ...DateFormat.EEEE(/*Localizations.localeOf(context).toLanguageTag()*/"pl_PL").dateSymbols.STANDALONEWEEKDAYS.skip(1),
      DateFormat.EEEE("pl_PL").dateSymbols.STANDALONEWEEKDAYS[0],
    ];

    return FutureBuilder<List<List<StandaloneEvent.StandaloneEvent>>>(
//      future: useMockup==true ? getMockup() : fetchActivities(http.Client(), entity.entityType, entity.id),
      future: () async {
        final activities = useMockup==true ? await getMockup() : await fetchActivities(http.Client(), entity.entityType, entity.id);
        List<List<StandaloneEvent.StandaloneEvent>> eventsByWeekdays = StandaloneEvent.getStandaloneEventsTable(activities);
        return eventsByWeekdays;
      } (),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.toString());
          return Scaffold(
              appBar: AppBar(
                  title: /* Text(entity.name), */ Text('Error'),
                  // backgroundColor: pickPrimaryColorForEntity(entity.id),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: "Reload",
                      onPressed: () async {  }
                    ),
                  ]
              ),
              body: UiMessageHandler(messageText: 'Network connection error: ' + snapshot.error.toString(), messageType: UiMessageType.error),
          );
        } else if (snapshot.hasData) {
            return DefaultTabController(
              length: snapshot.data!.first.isEmpty ? weekdayNames.length - 1 : weekdayNames.length,
              initialIndex: () {
                int weekday = DateTime.now().weekday;
                weekday--;
                if(snapshot.data!.first.isNotEmpty) weekday++;
                return weekday;
              } (),
              child: Scaffold(
                appBar: AppBar(
                  title: Text(entity.name),
                  backgroundColor: pickPrimaryColorForEntity(entity.id),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.link),
                      tooltip: "Copy link",
                      onPressed: () async { // todo: use variable to store moria address
                        String clipboardText = "http://moria.umcs.lublin.pl/";
                        switch(entity.entityType) {
                          case Models.EntityType.degree:
                            clipboardText += "students/";
                            break;

                          case Models.EntityType.room:
                            clipboardText += "room/";
                            break;

                          case Models.EntityType.teacher:
                            clipboardText += "teacher/";
                            break;
                        }

                        clipboardText += entity.id.toString();

                        await Clipboard.setData(ClipboardData(text: clipboardText));

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied link to the clipboard.")));
                      }
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border), // todo: implement favorites
                      tooltip: "Add to favorites",
                      onPressed: () { },
                    ),
                  ],
                  bottom: snapshot.data!.every((e) => e.isEmpty)
                          ? TabBar(
                              isScrollable: true,
                              tabs: () {
                                if(snapshot.data!.first.isEmpty) weekdayNames.removeAt(0);
                                return <Tab>[
                                  ...weekdayNames.map((element) => Tab(child: Text(element, style: TextStyle(fontStyle: element == unscheduled ? FontStyle.italic : FontStyle.normal),)))
                                ];
                              } ()
                            )
                          : null
                ),
                body: snapshot.data!.every((e) => e.isEmpty)
                    ? UiMessageHandler(messageText: 'This entity is empty.', messageType: UiMessageType.info)
                    : TabbedTimetableView(eventsByWeekdays: snapshot.data!)
              ),
            );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class TabbedTimetableView extends StatelessWidget {
  const TabbedTimetableView({Key? key, required this.eventsByWeekdays}) : super(key: key);

  final List<List<StandaloneEvent.StandaloneEvent>> eventsByWeekdays;

  @override
  Widget build(BuildContext context) {
    if(eventsByWeekdays.first.isEmpty) eventsByWeekdays.removeAt(0);

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
                          => EventPositionedWidget(
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

class EventPositionedWidget extends StatelessWidget {
  EventPositionedWidget({
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
    // degrees can be empty sometimes, so there's a need of implementing this check.
    final int groupNo = event.degrees.isNotEmpty ? event.degrees.first.group : 1 ;     // todo: check context degree,
    final int groupsTotal = event.degrees.isNotEmpty ? event.degrees.first.groups : 1; // ←
    final bool isGroup = (groupsTotal > 1) ? true : false; // todo: adjust width according to number of groups

    return Positioned(
      left: width * (0.1 * (groupNo - 1)),
      top: (event.startTime.hour.toDouble() + event.startTime.minute.toDouble() / 60 - dayStartTime.hour) * pxPerHour,
      height: height,
      width: isGroup ? width * (1 - 0.1 * (groupsTotal - 1)) : width,
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: EventCard(event: event)
      )
    );
  }
}
