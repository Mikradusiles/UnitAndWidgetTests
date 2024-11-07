class Student {
  final int id;
  final String firstName;
  final String secondName;

  Student({required this.id, this.firstName = "n/a", this.secondName = "n/a"});

  factory Student.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      throw ArgumentError('Missing required field: id');
    }
    return Student(
      id: json['id'],
      firstName: json['firstName'],
      secondName: json['secondName']
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Student otherStudent = other as Student;
    return otherStudent.id == id && otherStudent.firstName == firstName
      && otherStudent.secondName == secondName;
  }

  @override
  int get hashCode => id.hashCode ^ firstName.hashCode ^ secondName.hashCode;


}