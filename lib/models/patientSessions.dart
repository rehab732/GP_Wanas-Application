class sessions {
  final String state;
  final String date;
  final String startTime;
  final String endTime;
  final String? therapistFname;
  final String? therapistLname;

  const sessions(
      {required this.state,
      required this.date,
      required this.startTime,
      required this.endTime,
      this.therapistFname,
      this.therapistLname});

  factory sessions.fromJson(Map<String, dynamic> json) {
    return sessions(
      startTime: json['startTime'],
      endTime: json['endTime'],
      state: json['state'],
      date: json['date'],
    );
  }
}
