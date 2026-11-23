import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../core/widgets/async_button.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';
import '../../utils/validators.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({
    super.key,
    required this.owner,
    this.taskObject,
  });

  final ParseUser owner;
  final ParseObject? taskObject;

  bool get isEditing => taskObject != null;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _service = TaskService();
  String _priority = 'Medium';
  DateTime? _dueDate;
  bool _completed = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskObject != null) {
      final task = TaskModel.fromParse(widget.taskObject!);
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _priority = task.priority;
      _dueDate = task.dueDate;
      _completed = task.isCompleted;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (selected != null && mounted) setState(() => _dueDate = selected);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      if (widget.isEditing) {
        await _service.updateTask(
          task: widget.taskObject!,
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _priority,
          dueDate: _dueDate,
          isCompleted: _completed,
        );
      } else {
        await _service.createTask(
          owner: widget.owner,
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _priority,
          dueDate: _dueDate,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dueLabel = _dueDate == null ? 'No due date' : DateFormat('EEEE, d MMM yyyy').format(_dueDate!);

    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit task' : 'Create task')),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  validator: (v) => Validators.requiredText(v, label: 'Task title'),
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Task title',
                    hintText: 'e.g. Prepare DBSA normalization notes',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 4,
                  maxLines: 7,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    hintText: 'Add context, acceptance criteria, or notes…',
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: _priority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                  items: const ['Low', 'Medium', 'High']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (value) => setState(() => _priority = value ?? 'Medium'),
                ),
                const SizedBox(height: 14),
                Card(
                  child: ListTile(
                    onTap: _pickDate,
                    leading: const Icon(Icons.event_available_outlined),
                    title: const Text('Due date', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(dueLabel),
                    trailing: _dueDate == null
                        ? const Icon(Icons.chevron_right_rounded)
                        : IconButton(
                            tooltip: 'Clear due date',
                            onPressed: () => setState(() => _dueDate = null),
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                ),
                if (widget.isEditing) ...[
                  const SizedBox(height: 14),
                  Card(
                    child: SwitchListTile.adaptive(
                      value: _completed,
                      onChanged: (value) => setState(() => _completed = value),
                      title: const Text('Completed', style: TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: const Text('Toggle the task status.'),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                AsyncButton(
                  label: widget.isEditing ? 'Save changes' : 'Create task',
                  loading: _loading,
                  icon: widget.isEditing ? Icons.save_outlined : Icons.add_task_rounded,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
