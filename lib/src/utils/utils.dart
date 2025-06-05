import 'enums.dart';

String standardToString(StudentStandard standard) =>
    standard.toString().split('.').last;

StudentStandard stringToStandard(String value) => StudentStandard.values
    .firstWhere((e) => e.toString().split('.').last == value);

String statusToString(StudentStatus status) =>
    status.toString().split('.').last;

StudentStatus stringToStatus(String value) => StudentStatus.values
    .firstWhere((e) => e.toString().split('.').last == value);
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Enter Email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Enter Phone Number';
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value)) return 'Enter a valid 10-digit number';
    return null;
  }