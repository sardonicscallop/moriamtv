import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'models.dart' as Models;


final String moriaSiteAddress = "http://moria.umcs.lublin.pl";
final String moriaApiAddress = moriaSiteAddress + "/api";


Future<List<Models.Degree>> fetchDegrees(http.Client client) async
{
  final response = await client
      .get(Uri.parse(moriaApiAddress + "/students_list"));

  // Using the compute function to run in a separate isolate.
  return compute(parseDegrees, Utf8Decoder().convert(response.bodyBytes));
}

List<Models.Degree> parseDegrees(String responseBody)
{
  final parsed = jsonDecode(responseBody);

  return parsed['result']['array'].map<Models.Degree>((json) => Models.Degree.fromJson(json)).toList();
}


Future<List<Models.Teacher>> fetchTeachers(http.Client client) async
{
  final response = await client
      .get(Uri.parse(moriaApiAddress + "/students_list"));

  // Using the compute function to run in a separate isolate.
  return compute(parseTeachers, Utf8Decoder().convert(response.bodyBytes));
}

List<Models.Teacher> parseTeachers(String responseBody)
{
  final parsed = jsonDecode(responseBody);

  return parsed['result']['array'].map<Models.Teacher>((json) => Models.Teacher.fromJson(json)).toList();
}


Future<List<Models.Room>> fetchRooms(http.Client client) async
{
  final response = await client
      .get(Uri.parse(moriaApiAddress + "/room_list"));

  // Using the compute function to run in a separate isolate.
  return compute(parseRooms, Utf8Decoder().convert(response.bodyBytes));
}

List<Models.Room> parseRooms(String responseBody)
{
  final parsed = jsonDecode(responseBody);

  return parsed['result']['array'].map<Models.Room>((json) => Models.Room.fromJson(json)).toList();
}