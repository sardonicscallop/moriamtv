import 'modelsActivity.dart' as ActivityModels;

class Activity
{
  final int id;
  final int subject_id;
  final String subject;
  final List<ActivityModels.Event> event_array;
  final List<ActivityModels.Students> students_array;
  final List<ActivityModels.Teacher> teacher_array;
  final ActivityModels.Type type;

  const Activity({
    required this.id,
    required this.subject_id,
    required this.subject,
    required this.event_array,
    required this.students_array,
    required this.teacher_array,
    required this.type,
  });

  factory Activity.fromJson(Map<String, dynamic> json)
  {
    List eventObjJson = json['event_array'];
    List<ActivityModels.Event> _event = eventObjJson.map((eventJson) => ActivityModels.Event.fromJson(eventJson)).toList();

    List studentsObjJson = json['students_array'];
    List<ActivityModels.Students> _students = studentsObjJson.map((studentsJson) => ActivityModels.Students.fromJson(studentsJson)).toList();

    List teacherObjJson = json['teacher_array'];
    List<ActivityModels.Teacher> _teacher = teacherObjJson.map((teacherJson) => ActivityModels.Teacher.fromJson(teacherJson)).toList();

    return Activity(
        id: json['id'] as int,
        subject_id: json['subject_id'] as int,
        subject: json['subject'] as String,
        event_array: _event,
        students_array: _students,
        teacher_array: _teacher,
        type: ActivityModels.Type.fromJson(json['type'])
    );
  }
}

class Room
{
  final int id;
  final String name;
  final int department_id;
  final int quantity;

  const Room({
    required this.id,
    required this.name,
    required this.department_id,
    required this.quantity
  });

  factory Room.fromJson(Map<String, dynamic> json)
  {
    return Room(
      id: json['id'] as int,
      name: json['name'] as String,
      department_id: json['department_id'] as int,
      quantity: json['quantity'] as int
    );
  }
}

class Students
{
  final int id;
  final String name;

  const Students({
    required this.id,
    required this.name
  });

  factory Students.fromJson(Map<String, dynamic> json)
  {
    return Students(
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
  final String first_name;
  final String last_name;

  const Teacher({
    required this.id,
    required this.degree,
    required this.department,
    required this.first_name,
    required this.last_name
  });

  factory Teacher.fromJson(Map<String, dynamic> json)
  {
    return Teacher(
        id: json['id'],
        degree: json['degree'],
        department: json['department'],
        first_name: json['first_name'],
        last_name: json['last_name']
    );
  }
}