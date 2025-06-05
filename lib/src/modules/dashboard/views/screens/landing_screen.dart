import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scl_mgmt/src/modules/dashboard/views/widgets/dynamic_curved_header_delegate.dart';
import '../../../../controller/student_controller.dart';
import '../../../../utils/enums.dart';
import '../../../../controller/attendance_controller.dart';
import '../../../student/views/screens/stundents_list.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({super.key});

  final StudentController controller = Get.put(StudentController());
  AttendanceController attendanceController = Get.put(AttendanceController());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: DynamicCurvedHeaderDelegate(
                  expandedHeight: 180,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Students Overview',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildStatBox('All Students',
                        controller.totalActiveStudents, Colors.teal),
                    _buildStatBox('Inactive Students',
                        controller.totalInactiveStudents, Colors.orange,
                        status: StudentStatus.inactive),
                    _buildStatBox('Boys', controller.totalBoys, Colors.blue,
                        gender: 'Male'),
                    _buildStatBox('Girls', controller.totalGirls, Colors.pink,
                        gender: 'Female'),
                    _buildStatBox('Graduated Students',
                        controller.totalGraduatedStudents, Colors.blueGrey,
                        status: StudentStatus.graduated),
                  ],
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(onPressed: () {}),
      ),
    );
  }

  Widget _buildStatBox(String label, int count, Color color,
      {StudentStatus? status, String? gender}) {
    return InkWell(
      onTap: () {
        Get.to(() => StudentsListPage(
              defaultGender: gender,
              defaultStatus: status,
            ));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.79),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
