import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/models/task_model.dart';
import 'package:taskapp/screens/add_task_screen.dart';
import 'package:taskapp/services/task_service.dart';
import 'package:taskapp/typography.dart';
import 'package:taskapp/utils/loader.dart';
import 'package:taskapp/utils/theme_provider.dart';
import 'package:taskapp/utils/toast.dart';
import 'package:taskapp/widgets/text_widget.dart';
import 'package:toastification/toastification.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Variables
  List<Task> tasks = [];
  List<String> popMenuText = ["Edit", "Delete", "Mark as Complete"];
  List<IconData> poptMenuIcon = [
    Icons.edit,
    Icons.clear,
    Icons.check_box_outline_blank
  ];
  bool loader = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      _loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return loader
        ? Loader().buildTwoRotatingArc(context)
        : Scaffold(
            backgroundColor: themeProvider.isDarkMode ? priText : priBg,
            appBar: buildAppBar(),
            body: buildTaskList(),
            floatingActionButton: buildFloatingActionButton(),
          );
  }

  // build app bar
  AppBar buildAppBar() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AppBar(
      backgroundColor: themeProvider.isDarkMode ? priBg : pri,
      centerTitle: true,
      title: TextWidget(
          text: "Task Manager",
          fontWeight: semiBold,
          fontsize: bodyLarge + 2,
          color: themeProvider.isDarkMode ? priText : priBg,
          letterspacing: 1.2),
      actions: [
        IconButton(
          icon:
              Icon(themeProvider.isDarkMode ? Icons.sunny : Icons.nights_stay),
          onPressed: () => themeProvider.toggleTheme(),
          color: themeProvider.isDarkMode ? priText : priBg,
        ),
      ],
    );
  }

  // build task list
  Widget buildTaskList() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return tasks.isEmpty
        ? buildEmptyList()
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Column(
                children: [
                  ListTile(
                    leading: buildLeading(task),
                    title: buildTitle(task),
                    subtitle: buildSubtitle(task, index),
                    trailing: buildPopMenuButton(
                        index), // buildTrailing(index, task),
                  ),
                  // SizedBox(height: 2),
                  Divider(
                    color: themeProvider.isDarkMode ? priBg : Colors.black12,
                  ),
                  // SizedBox(height: 2),
                ],
              );
            },
          );
  }

  // build leadding
  Widget buildLeading(task) {
    return CircleAvatar(
      backgroundColor: secBg,
      radius: 20,
      child: task.priority == "High"
          ? Icon(Icons.priority_high_rounded, color: errorColor)
          : task.priority == "Medium"
              ? Icon(Icons.check_circle_outline_rounded, color: successColor)
              : Icon(Icons.arrow_downward_rounded, color: pri),
    );
  }

  // build title
  Widget buildTitle(task) {
    return Text(
      task.name,
      style: TextStyle(
        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
      ),
    );
  }

  // build subtitle
  Widget buildSubtitle(task, index) {
    return Text(
      '${task.priority} ${task.dueDate != null ? '| Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}' : ''}',
      style: TextStyle(fontSize: bodySmall, fontWeight: medium),
    );

    // Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         SizedBox(
    //           height: 20,
    //           width: 20,
    //           child: Checkbox(
    //             value: task.isCompleted,
    //             onChanged: (value) => _toggleCompletion(index),
    //           ),
    //         ),
    //         Text('Mark as done',
    //       style: TextStyle(fontSize: bodyMedium, fontWeight: medium),
    //     ),
    //       ],
    //     ),
  }

  // build trailing
  Widget buildTrailing(index, task) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: () => _editTask(index),
        ),
        Checkbox(
          value: task.isCompleted,
          onChanged: (value) => _toggleCompletion(index),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteTask(index),
        ),
      ],
    );
  }

  // build empty list
  Widget buildEmptyList() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_task_rounded,
            size: 100,
            color: themeProvider.isDarkMode ? priBg : secText,
          ),
          TextWidget(
            text: "No tasks available. Add some!",
            fontWeight: normal,
            fontsize: bodyMedium,
            color: themeProvider.isDarkMode ? priBg : secText,
          ),
        ],
      ),
    );
  }

  // Widget build floating Button
  Widget buildFloatingActionButton() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return FloatingActionButton(
      backgroundColor: themeProvider.isDarkMode ? priBg : pri,
      onPressed: _addTask,
      child: Icon(
        Icons.add,
        color: themeProvider.isDarkMode ? priText : priBg,
      ),
    );
  }

  // build Pop Menu Button
  Widget buildPopMenuButton(index) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return PopupMenuButton<String>(
      elevation: 3,
      icon: const Icon(CupertinoIcons.ellipsis_vertical_circle),
      iconSize: 25,
      color: priBg,
      iconColor: themeProvider.isDarkMode ? priBg : secText,
      position: PopupMenuPosition.under,
      onSelected: (String value) => navigatePage(value, index),
      itemBuilder: (BuildContext context) {
        return List.generate(popMenuText.length, (i) {
          return PopupMenuItem<String>(
            height: 20,
            value: popMenuText[i],
            padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon( 
                  i == 2 && tasks[index].isCompleted == true ? Icons.check_box_outlined : poptMenuIcon[i],
                  size: 18,
                  color: themeProvider.isDarkMode ? priText : secText,
                ),
                const SizedBox(width: 8),
                Text(
                  popMenuText[i], //i.toString()
                  style: TextStyle(
                      fontSize: bodyMedium,
                      fontWeight: medium,
                      color: themeProvider.isDarkMode ? priText : secText),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  // Navigate page from popmenubutton
  void navigatePage(value, index) {
    switch (value) {
      case "Edit":
        _editTask(index);
        break;

      case "Delete":
        _deleteTask(index);
        break;

      default:
        _toggleCompletion(index);
        break;
    }
  }

  // load task
  Future<void> _loadTasks() async {
    final loadedTasks = await TaskStorage.loadTasks();
    setState(() {
      tasks = loadedTasks;
      loader = false;
    });
  }

  // add task
  Future<void> _addTask() async {
    final newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen(isUpdate: false)),
    );
    // checking new task is not null
    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
      });
      TaskStorage.saveTasks(tasks);

      // Toast
      Toast().toastMessage(context, "Task added successfully.");
    }
  }

  // toggleCompletion
  void _toggleCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
    TaskStorage.saveTasks(tasks);
  }

  // delete task
  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    TaskStorage.saveTasks(tasks);

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        loader = false;
      });
    });
    // Toast
    Toast().toastMessage(context, "Task deleted successfully.");
  }

  // edit task
  Future<void> _editTask(int index) async {
    final updatedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          task: tasks[index],
          isUpdate: true,
        ),
      ),
    );

    // updated task is not null
    if (updatedTask != null) {
      setState(() => tasks[index] = updatedTask);
      TaskStorage.saveTasks(tasks);
      // Toast
      Toast().toastMessage(context, "Task updated successfully.");
    }
  }
}
