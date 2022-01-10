import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'models.dart' as Models;


final String moriaSiteAddress = "http://moria.umcs.lublin.pl";
final String moriaApiAddress = moriaSiteAddress + "/api";

Future<List<Models.Activity>> fetchActivities(http.Client client) async
{
  final response = await client
      .get(Uri.parse(moriaApiAddress + ""));

  // Using the compute function to run in a separate isolate.
  return compute(parseActivities, response.body);
}

// A function that converts a response body into a List.
List<Models.Activity> parseActivities(String responseBody)
{
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Models.Activity>((json) => Models.Activity.fromJson(json)).toList();
}



Future<List<Models.Degree>> fetchStudents(http.Client client) async
{
  final response = await client
      .get(Uri.parse(moriaApiAddress + "/students_list"));

  // Using the compute function to run in a separate isolate.
  return compute(parseStudents, response.body);
}

List<Models.Degree> parseStudents(String responseBody)
{
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Models.Degree>((json) => Models.Degree.fromJson(json)).toList();
}