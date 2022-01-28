import 'package:flutter/material.dart';
import 'modelsActivity.dart' as ActivityModels;

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
