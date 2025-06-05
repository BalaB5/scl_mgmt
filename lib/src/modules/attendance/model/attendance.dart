class Attendance {
  final String studentId;
  // Format: YYYY-MM-DD
  final String date;

  final bool isPresent;

  Attendance({
    required this.studentId,
    required this.date,
    required this.isPresent,
  });

  Map<String, dynamic> toMap() => {
    'studentId': studentId,
    'date': date,
    'isPresent': isPresent,
  };

  factory Attendance.fromMap(Map<String, dynamic> map) => Attendance(
    studentId: map['studentId'],
    date: map['date'],
    isPresent: map['isPresent'],
  );
}
