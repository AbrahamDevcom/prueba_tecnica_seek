import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../domain/models/task_mdl.dart';

class TaskController extends ChangeNotifier {
  final taskController = TextEditingController();
  late Box<Task> taskBox;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  String _filter = 'All';
  String get filter => _filter;
  set filter(value) {
    _filter = value;
    notifyListeners();
  }

  TaskController() {
    taskBox = Hive.box<Task>('tasks');
  }

  void addTask(String title) {
    final task = Task(title: title, date: selectedDate);
    taskBox.add(task);
    notifyListeners();
  }

  void deleteTask(Task task) {
    task.delete();
    notifyListeners();
  }

  void toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted;
    task.save();
    notifyListeners();
  }

  List<DateTime> getWeekDates() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    DateTime startOfWeek = now.subtract(Duration(days: currentWeekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  DateTime truncateTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<Task> getFilteredTasks() {
    return taskBox.values.where((task) {
      if (!(truncateTime(task.date) == truncateTime(selectedDate))) return false;
      if (filter == 'Pending' && task.isCompleted) return false;
      if (filter == 'Completed' && !task.isCompleted) return false;
      return true;
    }).toList();
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }
}
