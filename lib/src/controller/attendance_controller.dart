import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_controller.dart';

class AttendanceController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final StudentController studentController = Get.put(StudentController());

  var todayAttendance = <String, bool>{}.obs;
  var dailyPercentage = <String, double>{}.obs;
  var standardStudentCounts = <String, int>{}.obs;
  var standardPresentCounts = <String, int>{}.obs;



  Future<void> fetchTodayAttendance(String standardName) async {
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month}-${today.day}';

    final snapshot = await _db
        .collection('attendance')
        .doc(dateKey)
        .collection(standardName)
        .get();

    final map = <String, bool>{};
    for (var doc in snapshot.docs) {
      map[doc.id] = doc['present'] ?? false;
    }

    todayAttendance.assignAll(map);
    calculatePercentage(standardName);
  }

  Future<void> markAttendance(
      String standardName, String studentId, bool present) async {
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month}-${today.day}';

    await _db
        .collection('attendance')
        .doc(dateKey)
        .collection(standardName)
        .doc(studentId)
        .set({'present': present}, SetOptions(merge: true));

    todayAttendance[studentId] = present;
    calculatePercentage(standardName);
    studentController.fetchAllStudents();
  }

  Future<void> setStandardStudentCount(
      String standard, Future<int> futureCount) async {
    final count = await futureCount;
    standardStudentCounts[standard] = count;
    calculatePercentage(standard);
  }

  void calculatePercentage(String standard) {
    final students = todayAttendance.length;
    final present = todayAttendance.values.where((p) => p).length;
    final total = standardStudentCounts[standard] ?? students;

    if (total > 0) {
      dailyPercentage[standard] = (present / total) * 100;
    } else {
      dailyPercentage[standard] = 0;
    }

    standardPresentCounts[standard] = present;
  }

  int getTodayAttendanceCount(String standardName) {
    return standardPresentCounts[standardName] ?? 0;
  }

  double getTodayAttendancePercentage(String standardName) {
    return dailyPercentage[standardName] ?? 0;
  }
}
