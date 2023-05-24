import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vimigotech_assessment/Model/user.dart';

class ReadWriteJson {
  Future<List<User>> readLocalJSON() async {
    List<User> users = [];
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/dataset.json';
    File file = File(path);
    String? jsonString;
    try {
      jsonString = await file.readAsString();
    } catch (_) {
      jsonString = await rootBundle.loadString('lib/Data/dataset.json');
    }
    final jsonData = json.decode(jsonString);
    final userJsonList = jsonData['User'] as List<dynamic>;
    for (var item in userJsonList) {
      users.add(User.fromJson(item));
    }
    return users;
  }

  Future<File> _getLocalFile() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/dataset.json';
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
