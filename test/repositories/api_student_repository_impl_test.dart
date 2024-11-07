
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_and_widget_tests/models/student.dart';
import 'package:unit_and_widget_tests/repositories/api_student_repository_impl.dart';
import 'package:unit_and_widget_tests/services/api_service.dart';
import 'package:mocktail/mocktail.dart';


class MockApiService extends Mock implements ApiService {}

void main() {
  late ApiStudentRepositoryImpl studentRepository;
  late MockApiService mockApiService;
  late Student newStudent;

  setUp(() {
    mockApiService = MockApiService();
    studentRepository = ApiStudentRepositoryImpl(mockApiService);
    newStudent = Student(id: 3, firstName: 'John', secondName: 'Doe');
  });

  test('get students', () async {

    when(() => mockApiService.getStudentsFromApi())
        .thenAnswer((_) async => [{'id': 3, 'firstName': 'John', 'secondName': 'Doe'}]);

    final result = await studentRepository.fetchStudents();

    expect(result, containsOnce(newStudent));
    verify(() => mockApiService.getStudentsFromApi()).called(1);
  });

  test('add a student', () async {
    when(() => mockApiService.createStudent(any(), any())).thenAnswer((invocation) async {
      String first = invocation.positionalArguments[0];
      String second = invocation.positionalArguments[1];

      return Student(firstName: first, secondName: second, id:1);
    });

    final result = await studentRepository.addStudent("Bene", "Nass");

    expect(result.firstName, equals("Bene"));
    verify(() => mockApiService.createStudent("Bene", "Nass"));
  });
}
