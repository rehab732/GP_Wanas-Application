class therapist {
  final int id;
  final String f_name;
  final String l_name;
  final String email;
  final String phone;
  final String speciality;
  final String education;
  final String experiance;
  final double rate;
  final String image;

  const therapist({
    required this.id,
    required this.f_name,
    required this.l_name,
    required this.email,
    required this.phone,
    required this.speciality,
    required this.education,
    required this.experiance,
    required this.rate,
    required this.image,
  });

  factory therapist.fromJson(Map<String, dynamic> json) {
    return therapist(
        id: json['id'],
        f_name: json['f_name'],
        l_name: json['l_name'],
        email: json['email'],
        phone: json[' phone'],
        speciality: json['speciality'],
        education: json['education'],
        rate: json['rate'],
        experiance: json['experiance'],
        image: json['image']);
  }
}
