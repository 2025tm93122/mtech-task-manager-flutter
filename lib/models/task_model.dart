import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TaskModel {
  TaskModel({
    required this.raw,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
    this.dueDate,
  });

  final ParseObject raw;
  final String title;
  final String description;
  final String priority;
  final bool isCompleted;
  final DateTime? dueDate;

  String get id => raw.objectId ?? '';
  DateTime? get createdAt => raw.createdAt;
  DateTime? get updatedAt => raw.updatedAt;

  factory TaskModel.fromParse(ParseObject object) {
    return TaskModel(
      raw: object,
      title: object.get<String>('title') ?? 'Untitled task',
      description: object.get<String>('description') ?? '',
      priority: object.get<String>('priority') ?? 'Medium',
      isCompleted: object.get<bool>('isCompleted') ?? false,
      dueDate: object.get<DateTime>('dueDate'),
    );
  }
}
