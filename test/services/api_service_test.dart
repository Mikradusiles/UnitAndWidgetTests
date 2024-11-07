import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:unit_and_widget_tests/models/student.dart';
import 'package:unit_and_widget_tests/services/api_service.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])

main() {

  group("getStudentsFromApi", () {

    test("returns student list if http call completes successfully", () async {
      final client = MockClient();
      final uri = Uri.parse('https://test_url');

      when(client
        .get(any))
        .thenAnswer((_) async =>
        http.Response(jsonEncode([{"id": 1, "firstName": "Alice", "secondName": "Johnson"},
              {"id": 2, "firstName": "Bob", "secondName": "Smith"},
              {"id": 3, "firstName": "Charlie", "secondName": "Brown"},
              {"id": 4, "firstName": "Diana", "secondName": "Prince"}]), 200));

      final apiService = ApiService(baseUrl: 'https://test_url', client: client);
      final result = await apiService.getStudentsFromApi();

      Map expectedStudent = {"id": 1, "firstName": "Alice", "secondName": "Johnson"};

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result, hasLength(4));
      expect(result, containsOnce(expectedStudent));

      verify(client.get(uri));
      verifyNever(client.post(any));

    });

    test("throws exception on bad answer", () async {
      final client = MockClient();


      when(client
          .get(any))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final apiService = ApiService(baseUrl: 'https://test_url', client: client);
      expect(apiService.getStudentsFromApi(), throwsException);
    });
  });


  group("create Student", ()
  {
    test("return student after post", () async {
      final client = MockClient();

      when(client
          .post(any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),))
          .thenAnswer((invocation) async {
        final body = invocation.namedArguments[const Symbol('body')] as String;
        final data = json.decode(body);

        final response = {
          "id": 1,
          "firstName": data['firstName'],
          "secondName": data['secondName']
        };

        return http.Response(jsonEncode(response), 201);
      });

      final apiService = ApiService(
          baseUrl: 'https://test_url', client: client);
      final result = await apiService.createStudent("Alice", "Johnson");

      Student expectedStudent = Student(id: 1, firstName: "Alice", secondName: "Johnson");


      expect(result, isA<Student>());
      expect(result, equals(expectedStudent));
    });
  });


}