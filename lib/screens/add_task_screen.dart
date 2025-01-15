import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/constant.dart';
import 'package:taskapp/controllers/task_controller.dart';
import 'package:taskapp/models/task_model.dart';
import 'package:taskapp/typography.dart';
import 'package:taskapp/utils/functions.dart';
import 'package:taskapp/utils/loader.dart';
import 'package:taskapp/utils/theme_provider.dart';
import 'package:taskapp/widgets/text_widget.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  bool? isUpdate;

  AddTaskScreen({super.key, this.task, required this.isUpdate});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends StateMVC<AddTaskScreen> {
  // constructor
  late TaskController taskController;

  _AddTaskScreenState() : super(TaskController()) {
    taskController = controller as TaskController;
  }

  // Variable
  TextEditingController _nameController = TextEditingController();
  final TextEditingController _startDate = TextEditingController();
  late String _selectedPriority = priorityList[1];
  DateTime? _selectedDate;
  bool loader = false;

  @override
  void initState() {
    if (widget.isUpdate == true) {
      int findIndex = priorityList.indexWhere(
        (element) => widget.task?.priority == element,
      );
      setState(() {
        _nameController = TextEditingController(text: widget.task?.name ?? '');
        _selectedPriority = priorityList[findIndex];
        if (widget.task?.dueDate != null) {
          _selectedDate = widget.task?.dueDate;
          _startDate.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: loader
          ? Loader().buildTwoRotatingArc(context)
          : Scaffold(
              backgroundColor: themeProvider.isDarkMode ? priText : priBg,
              appBar: buildAppBar(),
              body: body(),
            ),
    );
  }

  // build app bar
  AppBar buildAppBar() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AppBar(
      backgroundColor: themeProvider.isDarkMode ? priBg : pri,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back,
          color: themeProvider.isDarkMode ? priText : priBg,
        ),
      ),
      title: TextWidget(
        text: widget.isUpdate == true ? "Update Task" : "Add Task",
        fontWeight: semiBold,
        fontsize: bodyLarge + 2,
        color: themeProvider.isDarkMode ? priText : priBg,
        letterspacing: 1.2,
      ),
    );
  }

  // build body
  Widget body() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: taskController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: "Task Name",
              fontWeight: normal,
              fontsize: bodyMedium,
              color: themeProvider.isDarkMode ? priBg : secText,
            ),
            SizedBox(height: 5),
            buildTaskNameField(),
            const SizedBox(height: 30),
            TextWidget(
              text: "Priority",
              fontWeight: normal,
              fontsize: bodyMedium,
              color: themeProvider.isDarkMode ? priBg : secText,
            ),
            SizedBox(height: 5),
            buildPriorityList(),
            const SizedBox(height: 30),
            TextWidget(
              text: "Due Date",
              fontWeight: normal,
              fontsize: bodyMedium,
              color: themeProvider.isDarkMode ? priBg : secText,
            ),
            SizedBox(height: 5),
            buildDueDate(),
            const SizedBox(height: 30),
            SizedBox(height: 30),
            buildSaveButton(),
          ],
        ),
      ),
    );
  }

  // build task name
  Widget buildTaskNameField() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Material(
      elevation: 2,
      color: themeProvider.isDarkMode ? priBg : secBg,
      shadowColor: themeProvider.isDarkMode ? priBg : secBg,
      borderRadius: BorderRadius.circular(10),
      child: TextFormField(
        controller: _nameController,
        validator: (value) {
          taskController.task.name = value;
          if (taskController.validateName(value) == "pass") {
            return null;
          } else {
            return taskController.validateName(value);
          }
        },
        style: TextStyle(
          fontSize: bodyMedium,
          fontWeight: normal,
          color: secText,
        ),
        decoration: InputDecoration(
          hintText: "Enter task name",
          hintStyle: TextStyle(
            fontSize: bodyMedium,
            fontWeight: normal,
            color: secText,
          ),
          prefixIcon: Icon(Icons.note_alt_outlined),
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: secText, width: 0.5)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: secText, width: 0.5)),
          filled: true,
          fillColor: themeProvider.isDarkMode ? priBg : secBg,
        ),
      ),
    );
  }

  // Widget build priority list
  Widget buildPriorityList() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Material(
      elevation: 2,
      color: themeProvider.isDarkMode ? priBg : secBg,
      shadowColor: themeProvider.isDarkMode ? priBg : secBg,
      borderRadius: BorderRadius.circular(10),
      child: Theme(
        data: Theme.of(context)
            .copyWith(focusColor: Colors.transparent, cardColor: secBg),
        child: DropdownButtonFormField(
          iconEnabledColor: priText,
          isExpanded: true,
          dropdownColor: Colors.white,
          focusColor: priText,
          menuMaxHeight: 250,
          hint: TextWidget(
            text: "Choose Priority",
            fontsize: bodyMedium,
            fontWeight: normal,
            color: secText,
          ),
          validator: (value) {
            if (value == null) {
              return 'Please choose the priority.';
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(_selectedPriority == "High"
                ? Icons.priority_high_rounded
                : _selectedPriority == "Medium"
                    ? Icons.check_circle_outline
                    : Icons.arrow_downward_rounded),
            filled: true,
            fillColor: themeProvider.isDarkMode ? priBg : secBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: secText, width: 0.5)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: secText, width: 0.5)),
          ),
          value: _selectedPriority,
          items: priorityList.map(
            (String data) {
              return DropdownMenuItem(
                value: data,
                child: TextWidget(
                  text: data,
                  color: secText,
                  fontsize: bodyMedium,
                  fontWeight: normal,
                  letterspacing: 1.2,
                ),
              );
            },
          ).toList(),
          onChanged: (String? value) {
            setState(() {
              _selectedPriority = value!;
            });
          },
          icon: const Icon(
            Icons.arrow_drop_down_circle_outlined,
            size: 20,
          ),
        ),
      ),
    );
  }

  // Widget build due date
  Widget buildDueDate() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Material(
        elevation: 2,
        color: themeProvider.isDarkMode ? priBg : secBg,
        shadowColor: themeProvider.isDarkMode ? priBg : secBg,
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          controller: _startDate,
          style: TextStyle(
            fontSize: bodyMedium,
            fontWeight: normal,
            color: secText,
          ),
          onTap: () async {
            DateTime? pickDate = await showDatePicker(
              context: context,
              firstDate: DateTime(1950),
              lastDate: DateTime(2035),
            );
            setState(() {
              _startDate.text = DateFormat('yyyy-MM-dd').format(pickDate!);
              _selectedDate = DateTime.parse(_startDate.text);
            });
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.date_range_rounded),
            hintText: "Choose due date",
            hintStyle: TextStyle(
              fontSize: bodyMedium,
              fontWeight: normal,
              color: secText,
            ),
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: secText, width: 0.5)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: secText, width: 0.5)),
            filled: true,
            fillColor: themeProvider.isDarkMode ? priBg : secBg,
          ),
        ));
  }

  // build Save Button
  Widget buildSaveButton() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () => _saveTask(),
        child: Material(
          elevation: 4,
          shadowColor: secBg,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode ? priBg : pri,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: TextWidget(
                text: widget.isUpdate == true ? "Update" : "Save",
                color: themeProvider.isDarkMode ? priText : terText,
                fontsize: bodyMedium,
                fontWeight: semiBold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // save task
  void _saveTask() {
    if (taskController.formKey.currentState!.validate()) {
      setState(() {
        loader = true;
      });
      Future.delayed(Duration(seconds: 2), () {
        final updatedTask = Task(
          name: GlobalFuntions().capitalize(_nameController.text),
          dueDate: _selectedDate,
          priority: _selectedPriority,
          isCompleted: widget.task?.isCompleted ?? false,
        );
        setState(() {
          loader = false;
        });
        Navigator.pop(context, updatedTask);
      });
    }
  }
}
