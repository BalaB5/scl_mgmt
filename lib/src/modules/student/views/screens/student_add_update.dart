import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/student_controller.dart';
import '../../../../models/student.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/utils.dart';

class StudentAddUpdatePage extends StatefulWidget {
  final Student? student;
  const StudentAddUpdatePage({super.key, this.student});

  @override
  State<StudentAddUpdatePage> createState() => _StudentAddUpdatePageState();
}

class _StudentAddUpdatePageState extends State<StudentAddUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final StudentController controller = Get.find();

  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController ageController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController fatherController;
  late TextEditingController motherController;
  late TextEditingController joiningDateController;

  String? selectedGender;
  StudentStandard? selectedStandard;
  StudentStatus? selectedStatus;

  DateTime? selectedDob;
  DateTime? selectedJoiningDate;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    nameController = TextEditingController(text: s?.name ?? '');
    selectedDob = s?.dob;
    dobController = TextEditingController(
      text: s?.dob != null ? _formatDate(s!.dob) : '',
    );
    ageController = TextEditingController(text: s?.age.toString() ?? '');
    selectedGender = s?.gender;
    phoneController = TextEditingController(text: s?.phoneNumber ?? '');
    emailController = TextEditingController(text: s?.email ?? '');
    addressController = TextEditingController(text: s?.address ?? '');
    fatherController = TextEditingController(text: s?.fatherName ?? '');
    motherController = TextEditingController(text: s?.motherName ?? '');
    selectedJoiningDate = s?.joiningDate;
    joiningDateController = TextEditingController(
      text: s?.joiningDate != null ? _formatDate(s!.joiningDate) : '',
    );
    selectedStandard = s?.standard;
    selectedStatus = s?.status ?? StudentStatus.active;
  }

  String _formatDate(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  int _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDob ?? DateTime(2005),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDob = picked;
        dobController.text = _formatDate(picked);
        ageController.text = _calculateAge(picked).toString();
      });
    }
  }

  Future<void> _pickJoiningDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedJoiningDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedJoiningDate = picked;
        joiningDateController.text = _formatDate(picked);
      });
    }
  }

  InputDecoration _decoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 178, 219, 253),
        title: Text(widget.student == null ? 'Add Student' : 'Update Student'),
      ),
      body: Container(
        color: Colors.grey.shade100,
        margin: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField(nameController, 'Name', icon: Icons.person),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDateField(
                      dobController,
                      'DOB',
                      _pickDob,
                      icon: Icons.cake,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: _buildField(
                      ageController,
                      'Age',
                      icon: Icons.calendar_today,
                      enabled: false,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              _buildGenderDropdown(),
              _buildField(
                phoneController,
                'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: validatePhone,
              ),
              _buildField(
                emailController,
                'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
              ),
              _buildField(addressController, 'Address', icon: Icons.home),
              _buildField(fatherController, 'Father Name', icon: Icons.man),
              _buildField(motherController, 'Mother Name', icon: Icons.woman),
              _buildDateField(
                joiningDateController,
                'Joining Date',
                _pickJoiningDate,
                icon: Icons.date_range,
              ),
              _buildDropdown<StudentStandard>(
                'Standard',
                selectedStandard,
                StudentStandard.values,
                (val) => setState(() => selectedStandard = val),
              ),
              _buildDropdown<StudentStatus>(
                'Status',
                selectedStatus,
                StudentStatus.values,
                (val) => setState(() => selectedStatus = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(
                  widget.student == null ? 'Add Student' : 'Update Student',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final student = Student(
                      id:
                          widget.student?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      dob: selectedDob ?? DateTime.now(),
                      age: int.tryParse(ageController.text) ?? 0,
                      gender: selectedGender!,
                      phoneNumber: phoneController.text,
                      email: emailController.text,
                      address: addressController.text,
                      fatherName: fatherController.text,
                      motherName: motherController.text,
                      standard: selectedStandard!,
                      joiningDate: selectedJoiningDate ?? DateTime.now(),
                      status: selectedStatus!,
                    );
                    if (widget.student == null) {
                      await controller.addStudent(student);
                    } else {
                      await controller.updateStudent(student);
                    }
                    Get.back();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    IconData? icon,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: 2,
        shadowColor: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        child: TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          validator:
              validator ??
              (val) => val == null || val.isEmpty ? 'Enter $label' : null,
          decoration: _decoration(label, icon: icon),
        ),
      ),
    );
  }

  Widget _buildDateField(
    TextEditingController controller,
    String label,
    VoidCallback onTap, {
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        shadowColor: Colors.grey.shade200,
        child: TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          decoration: _decoration(
            label,
            icon: icon,
          ).copyWith(suffixIcon: const Icon(Icons.calendar_today)),
          validator: (val) => val == null || val.isEmpty ? 'Pick $label' : null,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(
    String label,
    T? value,
    List<T> items,
    ValueChanged<T?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        shadowColor: Colors.grey.shade200,
        child: DropdownButtonFormField<T>(
          value: value,
          decoration: _decoration(label),
          items:
              items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.toString().split('.').last),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          validator: (val) => val == null ? 'Select $label' : null,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    final genders = ['Male', 'Female', 'Other'];
    return _buildDropdown<String>(
      'Gender',
      selectedGender,
      genders,
      (val) => setState(() => selectedGender = val),
    );
  }
}
