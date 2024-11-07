import '../models/student.dart';

abstract class StudentRepository {
  Future<List<Student>> fetchStudents();
  Future<Student> addStudent(String firstName, String secondName);
  int getVersion();
}