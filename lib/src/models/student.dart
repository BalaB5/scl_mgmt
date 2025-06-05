import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/enums.dart';
import '../utils/utils.dart';


// student_model.dart
class Student {
  String id;
  String name;
  DateTime dob;
  int age;
  String gender;
  String phoneNumber;
  String email;
  String address;
  String fatherName;
  String motherName;
  StudentStandard standard;
  DateTime joiningDate;
  DateTime? relieveDate;
  StudentStatus status;

  Student({
    required this.id,
    required this.name,
    required this.dob,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.fatherName,
    required this.motherName,
    required this.standard,
    required this.joiningDate,
    this.relieveDate,
    required this.status,
  });

  factory Student.fromMap(Map<String, dynamic> map) => Student(
    id: map['id'],
    name: map['name'],
    dob: (map['dob'] as Timestamp).toDate(),
    age: map['age'],
    gender: map['gender'],
    phoneNumber: map['phoneNumber'],
    email: map['email'],
    address: map['address'],
    fatherName: map['fatherName'],
    motherName: map['motherName'],
    standard: stringToStandard(map['standard']),
    joiningDate: (map['joiningDate'] as Timestamp).toDate(),
    relieveDate: map['relieveDate'] != null ? (map['relieveDate'] as Timestamp).toDate() : null,
    status: stringToStatus(map['status']),
  );
  

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'dob': dob,
    'age': age,
    'gender': gender,
    'phoneNumber': phoneNumber,
    'email': email,
    'address': address,
    'fatherName': fatherName,
    'motherName': motherName,
    'standard': standardToString(standard),
    'joiningDate': joiningDate,
    'relieveDate': relieveDate,
    'status': statusToString(status),
  };
  Student copyWith({
  String? id,
  String? name,
  DateTime? dob,
  int? age,
  String? gender,
  String? phoneNumber,
  String? email,
  String? address,
  String? fatherName,
  String? motherName,
  StudentStandard? standard,
  DateTime? joiningDate,
  StudentStatus? status,
}) {
  return Student(
    id: id ?? this.id,
    name: name ?? this.name,
    dob: dob ?? this.dob,
    age: age ?? this.age,
    gender: gender ?? this.gender,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    email: email ?? this.email,
    address: address ?? this.address,
    fatherName: fatherName ?? this.fatherName,
    motherName: motherName ?? this.motherName,
    standard: standard ?? this.standard,
    joiningDate: joiningDate ?? this.joiningDate,
    status: status ?? this.status,
  );
}

}
