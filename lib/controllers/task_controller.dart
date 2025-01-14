import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:taskapp/models/task_model.dart';

class TaskController extends ControllerMVC {

  // form key
  final formKey = GlobalKey<FormState>();

  late Task task;

  // contructor
  TaskController() {
    task = Task();
  }

  // validate name
  String? validateName(value) {
    // fail
    if (value == '' || value == null) {
      return "Please enter task name.";
    } 
    // pass
    else {
      return "pass";
    }
  }

  // validate name
  String? validateDueDate(value) {
    // fail
    if (value == '' || value == null) {
      return "Please enter due date.";
    } 
    // pass
    else {
      return "pass";
    }
  }

}