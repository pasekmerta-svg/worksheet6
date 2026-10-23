class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: (json['code'] ?? json['userId']?.toString() ?? '') as String,
      title: json['title'] as String,
      credits: (json['credits'] ?? 2) as int,
      status: (json['status'] as String?) ?? 'planned',
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'code': code,
        'title': title,
        'credits': credits,
        'status': status,
      };
}