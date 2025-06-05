import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../../controller/student_controller.dart';
import '../../../../models/student.dart';
import '../../../../utils/enums.dart';
import '../widgets/button.dart';
import '../../../../core/constants.dart';
import '../widgets/widget_functions.dart';
import 'student_add_update.dart';

class StudentDetailsPage extends StatefulWidget {
  final Student student;
  const StudentDetailsPage({super.key, required this.student});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  final StudentController controller = Get.find<StudentController>();

  Student get currentStudent {
    return controller.students.firstWhere(
      (s) => s.id == widget.student.id,
      orElse: () => widget.student,
    );
  }

  void refreshAndSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final student = currentStudent;

    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.lightBlue,
      padding: EdgeInsets.only(top: 30),
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: constraints.maxHeight * 0.20,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  // color: Color(0xffE2F3D4),
                                ),
                                child: Center(child: Text(student.name)),
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                child: SquareIconButton(
                                  icon: Icons.arrow_back_ios_outlined,
                                  width: 50,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  buttonColor: const Color.fromARGB(
                                    255,
                                    234,
                                    234,
                                    234,
                                  ),
                                  iconColor: Colors.orange,
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'delete') {
                                      await controller.deleteStudent(
                                        student.id,
                                      );
                                      Get.back();
                                    } else if (value == 'deactivate') {
                                      final updated = student.copyWith(
                                        status: StudentStatus.inactive,
                                      );
                                      await controller.updateStudent(updated);
                                      controller.fetchAllStudents();
                                      refreshAndSetState();
                                    }
                                  },
                                  itemBuilder:
                                      (context) => const [
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                        PopupMenuItem(
                                          value: 'deactivate',
                                          child: Text('Deactivate'),
                                        ),
                                      ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        addVerticalSpace(10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    addVerticalSpace(20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              student.name,
                                              style: TextStyle(),
                                            ),
                                            addVerticalSpace(5),
                                            RichText(
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons.menu_book_rounded,
                                                      color: Colors.red,
                                                      size: 15,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "  ${student.standard.name}",
                                                    style: textTheme.titleSmall!
                                                        .apply(
                                                          color: COLOR_GREY,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        RichText(
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Age : ",
                                                style: TextStyle(
                                                  color: COLOR_ORANGE,
                                                ),
                                              ),
                                              TextSpan(
                                                text: student.age.toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    addVerticalSpace(20),
                                    Divider(),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                    Icons.call,
                                                    color: Colors.orange,
                                                    size: 15,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: student.phoneNumber,
                                                  style: textTheme.bodyMedium!
                                                      .apply(
                                                        fontWeightDelta: 4,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                    Icons.email,
                                                    color: Colors.red,
                                                    size: 15,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: student.email,
                                                  style: textTheme.bodyMedium!
                                                      .apply(
                                                        fontWeightDelta: 4,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Text("Overview"),
                                    addVerticalSpace(10),
                                    infoRow('Address', student.address),
                                    infoRow('Father Name', student.fatherName),
                                    infoRow('Mother Name', student.motherName),
                                    infoRow('Standard', student.standard.name),
                                    infoRow(
                                      'Joining Date',
                                      student.joiningDate
                                          .toString()
                                          .split(' ')
                                          .first,
                                    ),
                                    infoRow('Status', student.status.name),
                                    addVerticalSpace(100),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: -35,
                                right: 20,
                                child: InkWell(
                                  onTap: () async {
                                    await Get.to(
                                      () => StudentAddUpdatePage(
                                        student: student,
                                      ),
                                    );
                                    await controller.fetchAllStudents();
                                    refreshAndSetState();
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.2),
                                          blurRadius: 10.0,
                                          spreadRadius: 5.0,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 35.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        // mainAxisAlignment: ,
        children: [
          Text(
            '$label :',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
  // Padding(
          //   padding: const EdgeInsets.all(20),
          //   child: ListView(
          //     children: [
          //       infoRow('Name', student.name),
          //       infoRow('DOB', student.dob.toString().split(' ').first),
          //       infoRow('Age', student.age.toString()),
          //       infoRow('Gender', student.gender),
          //       infoRow('Phone', student.phoneNumber),
          //       infoRow('Email', student.email),
          //       infoRow('Address', student.address),
          //       infoRow('Father Name', student.fatherName),
          //       infoRow('Mother Name', student.motherName),
          //       infoRow('Standard', student.standard.name),
          //       infoRow(
          //         'Joining Date',
          //         student.joiningDate.toString().split(' ').first,
          //       ),
          //       infoRow('Status', student.status.name),
          //       const SizedBox(height: 20),
          //       ElevatedButton(
          //         onPressed: () async {
          //           await Get.to(() => StudentAddUpdatePage(student: student));
          //           await controller.fetchAllStudents();
          //           refreshAndSetState();
          //         },
          //         child: const Text('Edit Details'),
          //       ),
          //     ],
          //   ),
          // ),
         