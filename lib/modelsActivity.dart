// These classes mustn't be located in models.dart, because of name collisions.

class Event
{
  final int id;
  final int weekday;
  final String startTime;
  final String length;
  final String breakLength;
  final String endTime;
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
      startTime: json['start_time'] as String,
      length: json['length'] as String,
      breakLength: json['break_length'] as String,
      endTime: json['end_time'] as String,
      roomId: json['room_id'] as int,
      roomName: json['room'] as String
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