import 'package:flutter/material.dart';
import 'modelsActivity.dart' as ActivityModels;
import 'models.dart' as Models;

class Subject {
  final int id;
  final String name;

  Subject({required this.id, required this.name});
}

class Room {
  final int id;
  final String name;

  Room({required this.id, required this.name});
}

class StandaloneEvent {
  final int eventId;
  final TimeOfDay startTime;
  final Duration length;
  final TimeOfDay endTime;
  final Duration breakLength;

  final int activityId;
  final Subject subject;
  final ActivityModels.Type type;
  final List<ActivityModels.Degree> degrees;
  final List<ActivityModels.Teacher> teachers;
  final Room room;
  // final MaterialColor? activityColor;

  StandaloneEvent({
    required this.eventId,
    required this.startTime,
    required this.length,
    required this.endTime,
    required this.breakLength,
    required this.activityId,
    required this.subject,
    required this.type,
    required this.degrees,
    required this.teachers,
    required this.room,
    // this.activityColor,
  });
}


List<List<StandaloneEvent>> getStandaloneEventsTable(List<Models.Activity> activities) {
  List<List<StandaloneEvent>> eventsByWeekdays = [ for(int k = 0; k < 8; k++) [] ];
  for (Models.Activity activity in activities) {
    for (ActivityModels.Event event in activity.events) {
      eventsByWeekdays[event.weekday].add(
          StandaloneEvent(
              eventId: event.id,
              startTime: event.startTime,
              length: event.length,
              endTime: event.endTime,
              breakLength: event.breakLength,

              activityId: activity.id,
              subject: Subject(
                  id: activity.subjectId, name: activity.subjectName),
              type: activity.type,
              degrees: activity.degrees,
              teachers: activity.teachers,
              room: Room(id: event.roomId, name: event.roomName)
          ));
    }
  }
  return eventsByWeekdays;
}