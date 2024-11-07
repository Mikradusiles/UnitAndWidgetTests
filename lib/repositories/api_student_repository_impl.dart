import '../models/student.dart';
import '../services/api_service.dart';
import 'student_repository.dart';

class ApiStudentRepositoryImpl implements StudentRepository {
  final ApiService apiService;

  ApiStudentRepositoryImpl(this.apiService);

  @override
  Future<List<Student>> fetchStudents() async {
    final data = await apiService.getStudentsFromApi();
    return data.map((json) => Student.fromJson(json)).toList();
  }

  @override
  Future<Student> addStudent(String firstName, String secondName) {
    return apiService.createStudent(firstName, secondName);
  }

  @override
  int getVersion() {
    return 1;
  }

}