import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TaskStats {
  const TaskStats({required this.total, required this.active, required this.done});

  final int total;
  final int active;
  final int done;
}

class TaskService {
  static const className = 'Task';

  QueryBuilder<ParseObject> buildLiveQuery({
    required String ownerId,
    String status = 'All',
    String search = '',
  }) {
    final query = QueryBuilder<ParseObject>(ParseObject(className))
      ..whereEqualTo('ownerId', ownerId)
      ..orderByDescending('updatedAt');

    if (status == 'Active') {
      query.whereEqualTo('isCompleted', false);
    } else if (status == 'Done') {
      query.whereEqualTo('isCompleted', true);
    }

    if (search.trim().isNotEmpty) {
      query.whereContains('title', search.trim(), caseSensitive: false);
    }

    return query;
  }

  Future<ParseObject> createTask({
    required ParseUser owner,
    required String title,
    required String description,
    required String priority,
    DateTime? dueDate,
  }) async {
    final ownerId = owner.objectId;
    if (ownerId == null) throw Exception('Invalid user session. Please log in again.');

    final task = ParseObject(className)
      ..set<String>('title', title.trim())
      ..set<String>('description', description.trim())
      ..set<String>('priority', priority)
      ..set<bool>('isCompleted', false)
      ..set<String>('ownerId', ownerId)
      ..set<String>('ownerEmail', owner.get<String>('email') ?? '');

    if (dueDate != null) task.set<DateTime>('dueDate', dueDate);
    task.setACL(ParseACL(owner: owner));

    final response = await task.save();
    if (!response.success) {
      throw Exception(response.error?.message ?? 'Could not create task.');
    }
    return response.result as ParseObject;
  }

  Future<ParseObject> updateTask({
    required ParseObject task,
    required String title,
    required String description,
    required String priority,
    required bool isCompleted,
    DateTime? dueDate,
  }) async {
    task
      ..set<String>('title', title.trim())
      ..set<String>('description', description.trim())
      ..set<String>('priority', priority)
      ..set<bool>('isCompleted', isCompleted);

    if (dueDate == null) {
      if (task.containsKey('dueDate')) {
        final unsetResponse = await task.unset('dueDate');
        if (!unsetResponse.success) {
          throw Exception(unsetResponse.error?.message ?? 'Could not clear due date.');
        }
      }
    } else {
      task.set<DateTime>('dueDate', dueDate);
    }

    final response = await task.save();
    if (!response.success) {
      throw Exception(response.error?.message ?? 'Could not update task.');
    }
    return response.result as ParseObject;
  }

  Future<void> toggleCompleted(ParseObject task) async {
    final next = !(task.get<bool>('isCompleted') ?? false);
    task.set<bool>('isCompleted', next);
    final response = await task.save();
    if (!response.success) {
      throw Exception(response.error?.message ?? 'Could not update task status.');
    }
  }

  Future<void> deleteTask(ParseObject task) async {
    final response = await task.delete();
    if (!response.success) {
      throw Exception(response.error?.message ?? 'Could not delete task.');
    }
  }

  Future<TaskStats> fetchStats(String ownerId) async {
    final query = QueryBuilder<ParseObject>(ParseObject(className))
      ..whereEqualTo('ownerId', ownerId)
      ..setLimit(1000);

    final objects = await query.find();
    final done = objects.where((e) => e.get<bool>('isCompleted') ?? false).length;
    return TaskStats(total: objects.length, active: objects.length - done, done: done);
  }
}
