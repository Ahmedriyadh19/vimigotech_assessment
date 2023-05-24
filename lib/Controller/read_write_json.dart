import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:vimigotech_assessment/Model/user.dart';

class ReadWriteJson {
  String path;
  ReadWriteJson({
    required this.path,
  });
  Future<List<User>> readLocalJSON() async {
    String jsonString = await rootBundle.loadString(path);
    final jsonData = json.decode(jsonString);
    List<User> users = [];
    final userJsonList = jsonData['User'] as List<dynamic>;
    for (var item in userJsonList) {
      users.add(User.fromJson(item));
    }
    return users;
  }

  Future<File> _getLocalFile() async {
    return File(path);
  }

  Future<void> writeLocalJSON(List<User> users) async {
    List<Map<String, dynamic>> userJsonList = users.map((user) => user.toJson()).toList();
    final jsonData = {'User': userJsonList};
    String jsonString = json.encode(jsonData);
    final file = await _getLocalFile();
    await file.writeAsString(jsonString);
  }
}
