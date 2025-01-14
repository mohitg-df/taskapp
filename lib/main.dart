import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/screens/task_list_screen.dart';
import 'package:taskapp/utils/theme_provider.dart';

void main() async{
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: TaskListScreen(),
    );
  }
}
