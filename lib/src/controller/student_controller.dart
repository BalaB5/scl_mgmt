// Required Packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:scl_mgmt/src/models/student.dart';

import '../utils/enums.dart';
import '../utils/utils.dart';

// student_controller.dart
class StudentController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RxList<Student> students = <Student>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllStudents();
  }

  Future<void> addStudent(Student student) async {
    await _db.collection('students').doc(student.id).set(student.toMap());
    fetchAllStudents();
  }

  Future<void> updateStudent(Student student) async {
    await _db.collection('students').doc(student.id).update(student.toMap());
    fetchAllStudents();
  }

  Future<void> deleteStudent(String id) async {
    await _db.collection('students').doc(id).delete();
    fetchAllStudents();
  }

  Future<void> fetchAllStudents() async {
    final snapshot = await _db.collection('students').get();
    students.value = snapshot.docs.map((doc) => Student.fromMap(doc.data())).toList();
  }

  Future<Student?> getStudentById(String id) async {
    final doc = await _db.collection('students').doc(id).get();
    return doc.exists ? Student.fromMap(doc.data()!) : null;
  }

  Future<List<Student>> getStudentsByStandard(StudentStandard standard) async {
    final snapshot =
        await _db
            .collection('students')
            .where('standard', isEqualTo: standardToString(standard))
            .get();
    return snapshot.docs.map((doc) => Student.fromMap(doc.data())).toList();
  }

  Future<int> getStudentCount(StudentStandard standard) async {
    final snapshot = await _db.collection('students').get();
    return snapshot.size;
  }

  Future<int> getStudentCountByStandard(StudentStandard standard) async {
    final snapshot =
        await _db
            .collection('students')
            .where('standard', isEqualTo: standardToString(standard))
            .get();
    return snapshot.size;
  }

  Map<StudentStandard, List<Student>> getFilteredGroupedStudents({
    required String searchQuery,
    StudentStandard? standard,
    StudentStatus? status,
    String? gender,
  }) {
    final filtered =
        students.where((student) {
          final matchesSearch = student.name.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
          final matchesStandard =
              standard == null || student.standard == standard;
          final matchesStatus = status == null || student.status == status;
          final matchesGender =
              gender == null ||
              student.gender.toLowerCase() == gender.toLowerCase();
          return matchesSearch &&
              matchesStandard &&
              matchesStatus &&
              matchesGender;
        }).toList();

    final grouped = <StudentStandard, List<Student>>{};
    for (var student in filtered) {
      grouped.putIfAbsent(student.standard, () => []).add(student);
    }
    return grouped;
  }
    Future<Map<StudentStandard, int>> getStudentCountsByStandard() async {
    Map<StudentStandard, int> counts = {};

    for (var standard in StudentStandard.values) {
      final count = students.where((s) => s.standard == standard).length;
      counts[standard] = count;
    }

    return counts;
  }

}
