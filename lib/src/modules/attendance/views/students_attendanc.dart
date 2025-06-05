import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/attendance_controller.dart';
import '../../../controller/student_controller.dart';
import '../../../utils/enums.dart';

class StudentsAttendanc extends StatefulWidget {
  final StudentStandard standard;

  const StudentsAttendanc({super.key, required this.standard});

  @override
  State<StudentsAttendanc> createState() => _StudentsAttendancState();
}

class _StudentsAttendancState extends State<StudentsAttendanc> {
  final AttendanceController attendanceController = Get.put(
    AttendanceController(),
  );
  StudentController studentController = Get.put(StudentController());

  @override
  void initState() {
    super.initState();
    attendanceController.fetchTodayAttendance(widget.standard.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('${widget.standard.name} Attendance'),
        backgroundColor: const Color.fromARGB(255, 178, 219, 253),
      ),
      body: Obx(() {
        final attendance = attendanceController.todayAttendance;

        final students = studentController.students
            .where((s) => s.standard == widget.standard)
            .toList();

        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            final isPresent = attendance[student.id] ?? false;

            return CheckboxListTile(
              title: Text(student.name),
              value: isPresent,
              onChanged: (val) {
                if (val != null) {
                  attendanceController.markAttendance(
                    widget.standard.name,
                    student.id,
                    val,
                  );
                }
              },
            );
          },
        );
      }),
    );
  }
}
