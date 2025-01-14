class Task {
  String? name;
  DateTime? dueDate;
  String? priority;
  bool isCompleted;

  Task({
    this.name,
    this.dueDate,
    this.priority,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'dueDate': dueDate?.toIso8601String(),
        'priority': priority,
        'isCompleted': isCompleted,
      };

  static Task fromMap(Map<String, dynamic> map) => Task(
        name: map['name'],
        dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
        priority: map['priority'],
        isCompleted: map['isCompleted'],
      );
}
