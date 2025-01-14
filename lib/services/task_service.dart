import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskapp/models/task_model.dart';

class TaskStorage {
  static const String _tasksKey = 'tasks';

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_tasksKey) ?? [];
    return data.map((e) => Task.fromMap(jsonDecode(e))).toList();
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final data = tasks.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(_tasksKey, data);
  }
}
