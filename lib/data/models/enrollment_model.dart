class Enrollment {
  final String id;
  final String userId;
  final String courseId;
  final DateTime enrolledAt;

  Enrollment({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.enrolledAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "courseId": courseId,
      "enrolledAt": enrolledAt.toIso8601String(),
    };
  }

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      id: map["id"],
      userId: map["userId"],
      courseId: map["courseId"],
      enrolledAt: DateTime.parse(map["enrolledAt"]),
    );
  }

}
