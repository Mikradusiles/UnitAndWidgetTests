import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_and_widget_tests/models/student.dart';
import 'package:unit_and_widget_tests/repositories/student_repository.dart';
import 'package:unit_and_widget_tests/views/student_widget.dart';

import 'student_widget_test.mocks.dart';

@GenerateMocks([StudentRepository])
MockStudentRepository mock = MockStudentRepository();

Widget createStudentWidget() => Provider<StudentRepository>(
      create: (_) => mock,
      child: MaterialApp(home: Scaffold(body: StudentWidget())),
    );

String missingField = 'Please fill in both fields';
String success = 'Student added successfully';

main() {
  setUp(() {
    when(mock.fetchStudents()).thenAnswer((_) async => [
          Student(id: 1, firstName: "Alice", secondName: "Johnson"),
          Student(id: 2, firstName: "Bob", secondName: "Smith"),
        ]);
    when(mock.addStudent(any, any)).thenAnswer((invocation) async {
      String first = invocation.positionalArguments[0];
      String second = invocation.positionalArguments[1];
      return Student(
        id: 3,
        firstName: first,
        secondName: second,
      );
    });
    when(mock.getVersion()).thenReturn(2);
  });

  testWidgets("Test student list", (tester) async {
    await tester.pumpWidget(createStudentWidget());

    await tester.pumpAndSettle();

    expect(find.text("Alice , Johnson"), findsOneWidget);
    expect(find.text("Bob , Smith"), findsOneWidget);

    verify(mock.fetchStudents()).called(1);
  });

  group("Test submit", () {
    testWidgets("Test submit with good input", (tester) async {
      await tester.pumpWidget(createStudentWidget());

      await tester.enterText(find.widgetWithText(TextField, "First Name"), "Bene");
      await tester.enterText(find.widgetWithText(TextField, "Second Name"), "Nass");
      await tester.tap(find.widgetWithText(ElevatedButton, "Submit"));

      await tester.pump();

      expect(find.text(success), findsOneWidget);

    });

    testWidgets("Test submit with bad input", (tester) async {
      await tester.pumpWidget(createStudentWidget());

      await tester.enterText(find.widgetWithText(TextField, "First Name"), "Bene");
      await tester.tap(find.widgetWithText(ElevatedButton, "Submit"));

      await tester.pump();

      expect(find.text(missingField), findsOneWidget);
    });
  });
}
