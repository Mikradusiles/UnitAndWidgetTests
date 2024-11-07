import 'package:test/test.dart';
import 'package:unit_and_widget_tests/models/student.dart';

void main() {

  late Map<String, dynamic> jsonData;
  setUp(() {
    jsonData = {"firstName": "test", "secondName": "test2"};
  });

  group("Test json factory", () {

    test("Creation fails without id", () {
      //expect(() => Student.fromJson(jsonData), isException);
      expect(() => Student.fromJson(jsonData), throwsA(isA<ArgumentError>()));
    });

    test("Creation works with id", () {
      jsonData["id"] = 1;
      Student expectedStudent = Student(id: 1, firstName: "test", secondName: "test2");
      Student wrongStudent = Student(id: 2);

      var student = Student.fromJson(jsonData);

      expect(student, equals(expectedStudent));
      expect(student, isNot(equals(wrongStudent)));
      expect(student.firstName, isNotEmpty);
    });

  });
}