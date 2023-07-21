import 'package:atom_cto_task/utils/constants.dart';

class Task {
  int? id;
  late String title;
  late String description;
  late DateTime dueDate;
  late bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json[Constants.id],
        title: json[Constants.title],
        description: json[Constants.description],
        dueDate: DateTime.parse(json[Constants.dueDate]),
        isCompleted: json[Constants.isCompleted] == 1 ? true : false,
      );

  Map<String, dynamic> toJson() {
    var temp = id != null ? {Constants.id: id} : {};
    return {
      ...temp,
      Constants.title: title,
      Constants.description: description,
      Constants.dueDate: dueDate.toString(),
      Constants.isCompleted: isCompleted ? 1 : 0,
    };
  }
}
