// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';
import 'package:vimigotech_assessment/Services/time_ago.dart';

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

  String toStringPrint({required bool format}) =>
      'Attendance:\nName: $user\nPhone Number: $phone\nCheck In: ${format ? CountTimeAgo(checkIn).timeAgo() : DateFormat('dd MMM yyyy, h:mm a').format(checkIn)})';
}
