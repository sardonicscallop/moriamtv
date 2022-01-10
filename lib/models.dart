import 'modelsActivity.dart' as ActivityModels;

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

class Room
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
  });

  factory Room.fromJson(Map<String, dynamic> json)
  {
    return Room(
      id: json['id'] as int,
      name: json['name'] as String,
      departmentId: json['department_id'] as int,
      quantity: json['quantity'] as int
    );
  }
}

class Degree
{
  final int id;
  final String name;

  const Degree({
    required this.id,
    required this.name
  });

  factory Degree.fromJson(Map<String, dynamic> json)
  {
    return Degree(
        id: json['id'],
        name: json['name']
    );
  }
}

class Teacher
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
    required this.lastName
  });

  factory Teacher.fromJson(Map<String, dynamic> json)
  {
    return Teacher(
        id: json['id'],
        degree: json['degree'],
        department: json['department'],
        firstName: json['first_name'],
        lastName: json['last_name']
    );
  }
}