// These classes mustn't be located in models.dart, because of name collisions.

class Event
{
  final int id;
  final int weekday;
  final String start_time;
  final String length;
  final String break_length;
  final String end_time;
  final int room_id;
  final String room;

  const Event({
    required this.id,
    required this.weekday,
    required this.start_time,
    required this.length,
    required this.break_length,
    required this.end_time,
    required this.room_id,
    required this.room,
  });

  factory Event.fromJson(Map<String, dynamic> json)
  {
    return Event(
      id: json['id'] as int,
      weekday: json['weekday'] as int,
      start_time: json['start_time'] as String,
      length: json['length'] as String,
      break_length: json['break_length'] as String,
      end_time: json['end_time'] as String,
      room_id: json['room_id'] as int,
      room: json['room'] as String
    );
  }
}

class Students
{
  final int id;
  final String name;
  final int group;
  final int groups;

  const Students({
    required this.id,
    required this.name,
    required this.group,
    required this.groups,
  });

  factory Students.fromJson(Map<String, dynamic> json)
  {
    return Students(
      id: json['id'] as int,
      name: json['name'] as String,
      group: json['group'] as int,
      groups: json['groups'] as int
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