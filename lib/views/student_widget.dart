  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import '../repositories/student_repository.dart';
  import '../models/student.dart';

  class StudentWidget extends StatefulWidget {
    @override
    _StudentWidgetState createState() => _StudentWidgetState();
  }

  class _StudentWidgetState extends State<StudentWidget> {
    final _firstNameController = TextEditingController();
    final _secondNameController = TextEditingController();
    String? _message;

    @override
    void dispose() {
      _firstNameController.dispose();
      _secondNameController.dispose();
      super.dispose();
    }

    void _addStudent() async {
      final firstName = _firstNameController.text.trim();
      final secondName = _secondNameController.text.trim();

      if (firstName.isEmpty || secondName.isEmpty) {
        setState(() {
          _message = 'Please fill in both fields';
        });
        return;
      }

      final studentRepository = Provider.of<StudentRepository>(context, listen: false);
      final newStudent = await studentRepository.addStudent(firstName, secondName);

      setState(() {
        _message = 'Student added successfully';
        _firstNameController.clear();
        _secondNameController.clear();
      });

      // Refresh the list of students
      studentRepository.fetchStudents();
    }

    @override
    Widget build(BuildContext context) {
      final studentRepository = Provider.of<StudentRepository>(context);

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _secondNameController,
              decoration: InputDecoration(labelText: 'Second Name'),
            ),
          ),
          ElevatedButton(
            onPressed: _addStudent,
            child: Text('Submit'),
          ),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _message!,
                style: TextStyle(color: Colors.green),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Student>>(
              future: studentRepository.fetchStudents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading students'));
                } else {
                  final students = snapshot.data!;
                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('ID: ${students[index].id}'),
                        subtitle: Text('${students[index].firstName} , ${students[index].secondName}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      );
    }
  }
