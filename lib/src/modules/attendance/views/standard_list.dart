import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/student_controller.dart';
import '../../../utils/enums.dart';
import '../controller/attendance_controller.dart';
import 'students_attendanc.dart';

class StandardsList extends StatelessWidget {
  final StudentController studentController = Get.put(StudentController());
  final AttendanceController attendanceController = Get.put(
    AttendanceController(),
  );

  StandardsList({super.key});

  @override
  Widget build(BuildContext context) {
    final standards = StudentStandard.values;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Select Standard'), backgroundColor: const Color.fromARGB(255, 178, 219, 253),),
      body: FutureBuilder(
        future: studentController.getStudentCountsByStandard(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final Map<StudentStandard, int> standardCounts = snapshot.data!;

          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(12),
            children:
                standards.map((standard) {
                  final count = standardCounts[standard] ?? 0;

                  return GestureDetector(
                    onTap:
                        () =>
                            Get.to(() => StudentsAttendanc(standard: standard)),
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      color: Colors.blue.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              standard.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Students: $count',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
