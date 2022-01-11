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