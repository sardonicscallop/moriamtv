// These classes mustn't be located in models.dart, because of name collisions.

import 'package:flutter/material.dart';

class Event
{
  final int id;
  final int weekday;
  final TimeOfDay startTime;
  final Duration length;
  final Duration breakLength;
  final TimeOfDay endTime;
  final int roomId;
  final String roomName;

  const Event({
    required this.id,
    required this.weekday,
    required this.startTime,
    required this.length,
    required this.breakLength,
    required this.endTime,
    required this.roomId,
    required this.roomName,
  });

  factory Event.fromJson(Map<String, dynamic> json)
  {
    return Event(
      id: json['id'] as int,
      weekday: json['weekday'] as int,
      startTime: TimeOfDay(hour: int.parse(json['start_time'].split(":")[0]), minute: int.parse(json['start_time'].split(":")[1])),
      length: Duration(hours: int.parse(json['length'].split(":")[0]), minutes: int.parse(json['length'].split(":")[1])),
      breakLength: Duration(hours: int.parse(json['break_length'].split(":")[0]), minutes: int.parse(json['break_length'].split(":")[1])),
      endTime: TimeOfDay(hour: int.parse(json['end_time'].split(":")[0]), minute: int.parse(json['end_time'].split(":")[1])),
      roomId: json['room_id'] as int,
      roomName: json['room'] as String,
    );
  }
}

class Degree
{
  final int id;
  final String name;
  final int group;
  final int groups;

  const Degree({
    required this.id,
    required this.name,
    required this.group,
    required this.groups,
  });

  factory Degree.fromJson(Map<String, dynamic> json)
  {
    return Degree(
      id: json['id'] as int,
      name: json['name'] as String,
      group: int.parse(json['group']),
      groups: int.parse(json['groups'])
    );
  }
}

class Teacher
{
  final int id;
  final String name;

  const Teacher({
    required this.id,
    required this.name,
  });

  factory Teacher.fromJson(Map<String, dynamic> json)
  {
    return Teacher(
      id: json['id'] as int,
      name: json['name'] as String
    );
  }
}

class Type
{
  final int id;
  final String name;
  final String shortcut;

  const Type({
    required this.id,
    required this.name,
    required this.shortcut,
  });

  factory Type.fromJson(Map<String, dynamic> json)
  {
    return Type(
      id: json['id'] as int,
      name: json['name'] as String,
      shortcut: json['shortcut'] as String
    );
  }
}