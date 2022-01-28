import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'data/models.dart' as Models;


final String moriaSiteAddress = "moria.umcs.lublin.pl";
final String moriaApiAddress = "/api";


class SearchResultCategory {
  String name;
  List<Models.SearchResult> items;

  SearchResultCategory({
    required this.name,
    required this.items
});
}


Future<List<SearchResultCategory>> fetchSearchResults(http.Client client) async
{
  List<SearchResultCategory> searchResults = [];
  searchResults.add(SearchResultCategory(name: "Degrees", items: await fetchDegrees(client)));
  searchResults.add(SearchResultCategory(name: "Teachers", items: await fetchTeachers(client)));
  searchResults.add(SearchResultCategory(name: "Rooms", items: await fetchRooms(client)));

  return searchResults;
}

Future<List<Models.Degree>> fetchDegrees(http.Client client) async
{
  final response = await client
      .get(Uri.http(moriaSiteAddress, moriaApiAddress + "/students_list"));

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
      .get(Uri.http(moriaSiteAddress, moriaApiAddress + "/teacher_list"));

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
      .get(Uri.http(moriaSiteAddress, moriaApiAddress + "/room_list"));

  // Using the compute function to run in a separate isolate.
  return compute(parseRooms, Utf8Decoder().convert(response.bodyBytes));
}

List<Models.Room> parseRooms(String responseBody)
{
  final parsed = jsonDecode(responseBody);
  return parsed['result']['array'].map<Models.Room>((json) => Models.Room.fromJson(json)).toList();
}


Future<List<Models.Activity>> fetchActivities(http.Client client, Models.EntityType entity, int id) async
{
  final String path;
  switch(entity) {
    case Models.EntityType.degree:
      path = moriaApiAddress + "/activity_list_for_students";
      break;
    case Models.EntityType.teacher:
      path = moriaApiAddress + "/activity_list_for_teacher";
      break;
    case Models.EntityType.room:
      path = moriaApiAddress + "/activity_list_for_room";
      break;
  }

  // Moria server can't be addressed using URI only, when you have to send
  // additional parameters. Somebody who coded this probably had no idea, that
  // it would be so much simpler, if parameters were parsed inside an URI, with
  // ?id=<int> on it. Instead, you have to attach them in a request body.

  http.Request request = http.Request("GET", Uri.http(moriaSiteAddress, path));
  request.body = '{ "id": "' + id.toString() + '"}';

  final response = await client.send(request);
  final responseBytes = await response.stream.toBytes();

  return compute(parseActivities, Utf8Decoder().convert(responseBytes));
}

Future<List<Models.Activity>> getMockup() async
{
  return compute(parseActivities, await rootBundle.loadString("assets/sampleActivityList.json"));
}

List<Models.Activity> parseActivities(String responseBody)
{
  final parsed = jsonDecode(responseBody);
  if(parsed['status'] == "error")
    throw Exception("Server reported error. Response: " + responseBody);

  // var picker = new MaterialColorPicker();

  return parsed['result']['array'].map<Models.Activity>((json) => Models.Activity.fromJson(json, /* picker.pickColorForActivity(json['id']) */)).toList();
}

