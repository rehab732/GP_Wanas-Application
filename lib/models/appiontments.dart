class Appiontments {
  final int? id;
  final int? therapist_id;
  final String date;
  final String startTime;
  final String endTime;

  Appiontments(
      {
       this.id,
       this.therapist_id,
      required this.date,
      required this.startTime,
      required this.endTime});

  factory Appiontments.fromJson(Map<String, dynamic> json) {
    return Appiontments(

      id: json['id'],
      therapist_id: json['tehrapist_id'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}
