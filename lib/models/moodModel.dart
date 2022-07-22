class Mood {
  final int id;
  final String date;
  final String time;
  final String content;
  final int value;
  final int patient_id;


  const Mood(
      {required this.id,
      required this.date,
      required this.time,
      required this.content,
      required this.value,
      required this.patient_id});

  factory Mood.fromJson(Map<String, dynamic> json) {
    return Mood(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      content: json['content'],
      value: json[' value'],
      patient_id: json['patient_id'],

    );
  }
}
