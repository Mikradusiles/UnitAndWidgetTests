import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/student.dart';

class ApiService {
  final String baseUrl;
  final http.Client client;

  ApiService({required this.baseUrl, required this.client});

  Future<List<Map<String, dynamic>>> getStudentsFromApi() async {

    final response = await client
        .get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<Student> createStudent(String firstName, String secondName) async {
    final body = json.encode({
      'firstName': firstName,
      'secondName': secondName,
    });
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: body
    );

    if (response.statusCode == 201) {
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create student');
    }
  }
}