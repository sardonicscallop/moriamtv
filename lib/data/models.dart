import 'modelsActivity.dart' as ActivityModels;


enum EntityType {
  degree,
  teacher,
  room
}

class SearchResult
{
  final int id;
  final String name;
  final EntityType entityType;

  const SearchResult({
    required this.id,
    required this.name,
    required this.entityType
  });
}

class Activity
{
  final int id;
  final int subjectId;
  final String subjectName;
  final List<ActivityModels.Event> events;
  final List<ActivityModels.Degree> degrees;
  final List<ActivityModels.Teacher> teachers;
  final ActivityModels.Type type;

  const Activity({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.events,
    required this.degrees,
    required this.teachers,
    required this.type,
  });

  factory Activity.fromJson(Map<String, dynamic> json)
  {
    List eventObjJson = json['event_array'];
    List<ActivityModels.Event> _event = eventObjJson.map((eventJson) => ActivityModels.Event.fromJson(eventJson)).toList();

    List studentsObjJson = json['students_array'];
    List<ActivityModels.Degree> _students = studentsObjJson.map((studentsJson) => ActivityModels.Degree.fromJson(studentsJson)).toList();

    List teacherObjJson = json['teacher_array'];
    List<ActivityModels.Teacher> _teacher = teacherObjJson.map((teacherJson) => ActivityModels.Teacher.fromJson(teacherJson)).toList();

    return Activity(
        id: json['id'] as int,
        subjectId: json['subject_id'] as int,
        subjectName: json['subject'] as String,
        events: _event,
        degrees: _students,
        teachers: _teacher,
        type: ActivityModels.Type.fromJson(json['type'])
    );
  }
}

class Room extends SearchResult
{
  final int id;
  final String name;
  final int departmentId;
  final int quantity;

  const Room({
    required this.id,
    required this.name,
    required this.departmentId,
    required this.quantity
  }) : super(id:id, name:name, entityType: EntityType.room);

  factory Room.fromJson(Map<String, dynamic> json)
  {
    return Room(
      id: json['id'] as int,
      name: json['name'] as String,
      departmentId: json['department_id'] as int,
      quantity: json['quanitiy'] as int // don't correct, server sends reply with this typo
    );
  }
}

class Degree extends SearchResult
{


  const Degree({
    required id,
    required name
  }) : super(id:id, name:name, entityType: EntityType.degree);

  factory Degree.fromJson(Map<String, dynamic> json)
  {
    return Degree(
        id: json['id'],
        name: json['name']
    );
  }
}

class Teacher extends SearchResult
{
  final int id;
  final String degree;
  final int department;
  final String firstName;
  final String lastName;

  const Teacher({
    required this.id,
    required this.degree,
    required this.department,
    required this.firstName,
    required this.lastName,
    required name,
  }): super(id:id,name:name, entityType: EntityType.teacher);

  factory Teacher.fromJson(Map<String, dynamic> json)
  {
    return Teacher(
        id: json['id'] as int,
        degree: json['degree'] as String,
        department: json['department_id'] as int,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        name: json['last_name'] + " " + json['first_name'] as String,
    );
  }
}