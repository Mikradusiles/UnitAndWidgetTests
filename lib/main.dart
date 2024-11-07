// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'repositories/api_student_repository_impl.dart';
import 'views/student_widget.dart';
import 'repositories/student_repository.dart';
import 'services/api_service.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MultiProvider(
      providers: [
        // API Service Provider
        Provider<ApiService>(
          create: (_) => ApiService(baseUrl: 'http://10.0.2.2:8000', client: http.Client()),  // URL for python server on emulator host
        ),
        // Repository Provider
        ProxyProvider<ApiService, StudentRepository>(
          update: (_, apiService, __) => ApiStudentRepositoryImpl(apiService),
        ),
      ],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student and Subject App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
      ),
      body: StudentWidget()
    );
  }
}
