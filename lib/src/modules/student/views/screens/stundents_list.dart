// students_list_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconic/iconic.dart';
import '../../../../controller/student_controller.dart';
import '../../../../utils/enums.dart';
import '../../../attendance/views/standard_list.dart';
import 'student_add_update.dart';
import 'students_details.dart';

class StudentsListPage extends StatelessWidget {
  final String? defaultGender;
  final StudentStandard? defaultStandard;
  final StudentStatus? defaultStatus;

  StudentsListPage({
    super.key,
    this.defaultGender,
    this.defaultStandard,
    this.defaultStatus,
  }) {
    if (defaultGender != null) selectedGender.value = defaultGender;
    if (defaultStandard != null) selectedStandard.value = defaultStandard;
    if (defaultStatus != null) selectedStatus.value = defaultStatus;
  }

  final StudentController controller = Get.put(StudentController());
  final RxString searchQuery = ''.obs;
  final Rx<StudentStandard?> selectedStandard = Rx<StudentStandard?>(null);
  final Rx<StudentStatus?> selectedStatus = Rx<StudentStatus?>(null);
  final Rx<String?> selectedGender = Rx<String?>(null);
  final TextEditingController search = TextEditingController();

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(fontSize: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchAllStudents();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Students'),
        backgroundColor: const Color.fromARGB(255, 178, 219, 253),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => StandardsList()),
              );
            },
            icon: const Icon(Icons.how_to_reg, color: Colors.black
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Obx(
              () => Material(
                elevation: 2,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(14),
                child: TextField(
                  controller: search,
                  decoration:
                      _inputDecoration('Search by name', icon: Icons.search)
                          .copyWith(
                    suffixIcon: searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchQuery.value = '';
                              search.clear();
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) => searchQuery.value = value,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => Material(
                      elevation: 2,
                      shadowColor: Colors.black26,
                      borderRadius: BorderRadius.circular(14),
                      child: DropdownButtonFormField<StudentStandard?>(
                        value: selectedStandard.value,
                        decoration: _inputDecoration('Standard'),
                        items: StudentStandard.values
                            .map((s) =>
                                DropdownMenuItem(value: s, child: Text(s.name)))
                            .toList(),
                        onChanged: (val) => selectedStandard.value = val,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => Material(
                      elevation: 2,
                      shadowColor: Colors.black26,
                      borderRadius: BorderRadius.circular(14),
                      child: DropdownButtonFormField<String?>(
                        value: selectedGender.value,
                        decoration: _inputDecoration('Gender'),
                        items: ['Male', 'Female', 'Other']
                            .map((g) =>
                                DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (val) => selectedGender.value = val,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => Material(
                      elevation: 2,
                      shadowColor: Colors.black26,
                      borderRadius: BorderRadius.circular(14),
                      child: DropdownButtonFormField<StudentStatus?>(
                        value: selectedStatus.value,
                        decoration: _inputDecoration('Status'),
                        items: StudentStatus.values
                            .map((s) =>
                                DropdownMenuItem(value: s, child: Text(s.name)))
                            .toList(),
                        onChanged: (val) => selectedStatus.value = val,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    searchQuery.value = '';
                    selectedStandard.value = null;
                    selectedGender.value = null;
                    selectedStatus.value = null;
                    search.clear();
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text("Clear Filters",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Obx(() {
                final grouped = controller.getFilteredGroupedStudents(
                  searchQuery: searchQuery.value,
                  standard: selectedStandard.value,
                  status: selectedStatus.value,
                  gender: selectedGender.value,
                );

                if (grouped.isEmpty) {
                  return const Center(child: Text('No students found.'));
                }

                return ListView(
                  children: grouped.entries.map((entry) {
                    final standard = entry.key;
                    final students = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 6),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue.shade200,
                          ),
                          child: Text(
                            'Standard: ${standard.name}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...students.map((student) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      const Color.fromARGB(255, 186, 211, 254),
                                  child: Icon(
                                    student.gender.toLowerCase() == 'female'
                                        ? Iconic.woman_head
                                        : student.gender.toLowerCase() == 'male'
                                            ? Iconic.man_head
                                            : Icons.person,
                                  ),
                                ),
                                title: Text(student.name),
                                subtitle: Text(
                                  'Gender: ${student.gender} | Status: ${student.status.name}',
                                ),
                                trailing: const Icon(Icons.open_in_new_sharp,
                                    size: 18),
                                onTap: () async {
                                  await Get.to(() =>
                                      StudentDetailsPage(student: student));
                                  controller.fetchAllStudents();
                                },
                              ),
                            )),
                      ],
                    );
                  }).toList(),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Get.to(() => const StudentAddUpdatePage());
          controller.fetchAllStudents();
        },
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.person_add_alt, color: Colors.white),
        label: const Text("Add", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
