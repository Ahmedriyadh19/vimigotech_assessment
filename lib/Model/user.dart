class User {
  final String user;
  final String phone;
  final DateTime checkIn;

  User({required this.user, required this.phone, required this.checkIn});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user: json['user'],
      phone: json['phone'],
      checkIn: DateTime.parse(json['check-in']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'phone': phone,
      'check-in': checkIn.toIso8601String(),
    };
  }
}
