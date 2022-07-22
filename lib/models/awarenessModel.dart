class Awareness {
  final double rate;
  final int id;
  final String content;
  final String title;
  final String image;
  final String type;

  Awareness(
      {required this.rate,
      required this.id,
      required this.content,
      required this.title,
      required this.image,
      required this.type});

  factory Awareness.fromJson(Map<String, dynamic> json) {
    return Awareness(
      rate: json['rate'],
      id: json['id'],
      content: json['content'],
      type: json['type'],
      image: json['image'],
      title: json['title'],
    );
  }
}
