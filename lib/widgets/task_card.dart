import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  Color _priorityColor(BuildContext context) {
    switch (task.priority) {
      case 'High':
        return Theme.of(context).colorScheme.error;
      case 'Low':
        return Theme.of(context).colorScheme.tertiary;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _priorityColor(context);
    final due = task.dueDate == null ? null : DateFormat('d MMM, yyyy').format(task.dueDate!.toLocal());

    return Card(
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                button: true,
                label: task.isCompleted ? 'Mark task active' : 'Mark task completed',
                child: IconButton.filledTonal(
                  onPressed: onToggle,
                  tooltip: task.isCompleted ? 'Mark active' : 'Mark completed',
                  icon: Icon(
                    task.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          tooltip: 'Task actions',
                          onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit task')),
                            PopupMenuItem(value: 'delete', child: Text('Delete task')),
                          ],
                        ),
                      ],
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            '${task.priority} priority',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
                          ),
                        ),
                        if (due != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.event_outlined, size: 14),
                                const SizedBox(width: 5),
                                Text(due, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
