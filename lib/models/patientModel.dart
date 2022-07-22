class Patient {
  final int id;
  final String f_name;
  final String l_name;
  final String email;
  final String phone;
  final String diagnose;

  const Patient(
      {required this.id,
      required this.f_name,
      required this.l_name,
      required this.email,
      required this.phone,
      required this.diagnose});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      f_name: json['f_name'],
      l_name: json['l_name'],
      email: json['email'],
      phone: json[' phone'],
      diagnose: json['diagnose'],
    );
  }
}
