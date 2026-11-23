import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../models/task_model.dart';
import '../../services/auth_service.dart';
import '../../services/task_service.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/task_card.dart';
import '../tasks/task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.user,
    required this.onLoggedOut,
  });

  final ParseUser user;
  final VoidCallback onLoggedOut;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _taskService = TaskService();
  final _authService = const AuthService();
  final _searchController = TextEditingController();

  Timer? _searchDebounce;

  List<ParseObject> _tasks = [];

  TaskStats _stats = const TaskStats(
    total: 0,
    active: 0,
    done: 0,
  );

  bool _loading = true;
  bool _loggingOut = false;

  String? _error;
  String _filter = 'All';
  String _search = '';

  String get _ownerId => widget.user.objectId!;

  String get _displayName {
    final displayName = widget.user.get<String>('displayName');

    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName.trim();
    }

    final email = widget.user.get<String>('email') ?? 'Student';
    return email.split('@').first;
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);

    _loadTasks();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();

    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();

    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(
      const Duration(milliseconds: 300),
      () {
        if (!mounted) return;

        setState(() {
          _search = _searchController.text.trim();
        });
      },
    );
  }

  Future<void> _loadTasks() async {
    if (!mounted) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final query = QueryBuilder<ParseObject>(
        ParseObject(TaskService.className),
      )
        ..whereEqualTo('ownerId', _ownerId)
        ..orderByDescending('updatedAt')
        ..setLimit(1000);

      final response = await query.query();

      if (!response.success) {
        throw Exception(
          response.error?.message ?? 'Could not load tasks.',
        );
      }

      final results = response.results;

      final tasks = results == null
          ? <ParseObject>[]
          : results.whereType<ParseObject>().toList();

      final done = tasks
          .where(
            (task) => task.get<bool>('isCompleted') ?? false,
          )
          .length;

      if (!mounted) return;

      setState(() {
        _tasks = tasks;

        _stats = TaskStats(
          total: tasks.length,
          active: tasks.length - done,
          done: done,
        );

        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = error
            .toString()
            .replaceFirst('Exception: ', '');
      });
    }
  }

  List<ParseObject> get _visibleTasks {
    Iterable<ParseObject> result = _tasks;

    if (_filter == 'Active') {
      result = result.where(
        (task) => !(task.get<bool>('isCompleted') ?? false),
      );
    } else if (_filter == 'Done') {
      result = result.where(
        (task) => task.get<bool>('isCompleted') ?? false,
      );
    }

    final search = _search.toLowerCase();

    if (search.isNotEmpty) {
      result = result.where((task) {
        final title =
            (task.get<String>('title') ?? '').toLowerCase();

        final description =
            (task.get<String>('description') ?? '').toLowerCase();

        final priority =
            (task.get<String>('priority') ?? '').toLowerCase();

        return title.contains(search) ||
            description.contains(search) ||
            priority.contains(search);
      });
    }

    return result.toList();
  }

  Future<void> _openTaskForm([ParseObject? task]) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TaskFormScreen(
          owner: widget.user,
          taskObject: task,
        ),
      ),
    );

    if (changed == true) {
      await _loadTasks();
    }
  }

  Future<void> _toggle(ParseObject task) async {
    try {
      await _taskService.toggleCompleted(task);
      await _loadTasks();
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _delete(ParseObject task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete task?'),
        content: const Text(
          'This permanently removes the task from the cloud database.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _taskService.deleteTask(task);
      await _loadTasks();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task deleted successfully.'),
        ),
      );
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _logout() async {
    setState(() => _loggingOut = true);

    try {
      await _authService.logout();

      if (mounted) {
        widget.onLoggedOut();
      }
    } catch (error) {
      _showError(error);

      if (mounted) {
        setState(() => _loggingOut = false);
      }
    }
  }

  void _showError(Object error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error.toString().replaceFirst('Exception: ', ''),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleTasks = _visibleTasks;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading ? null : () => _openTaskForm(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New task'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadTasks,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  8,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi, $_displayName 👋',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight:
                                            FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Plan clearly. Finish confidently.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          IconButton.filledTonal(
                            tooltip: 'Logout',
                            onPressed:
                                _loggingOut ? null : _logout,
                            icon: _loggingOut
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.logout_rounded,
                                  ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      Row(
                        children: [
                          StatCard(
                            label: 'Total',
                            value: _stats.total,
                            icon: Icons.layers_outlined,
                          ),
                          const SizedBox(width: 10),
                          StatCard(
                            label: 'Active',
                            value: _stats.active,
                            icon: Icons.bolt_outlined,
                          ),
                          const SizedBox(width: 10),
                          StatCard(
                            label: 'Done',
                            value: _stats.done,
                            icon: Icons.task_alt_rounded,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: _searchController,
                        textInputAction:
                            TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Search tasks',
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                          ),
                          suffixIcon:
                              _searchController.text.isEmpty
                                  ? null
                                  : IconButton(
                                      tooltip: 'Clear search',
                                      onPressed: () {
                                        _searchController
                                            .clear();
                                      },
                                      icon: const Icon(
                                        Icons.close_rounded,
                                      ),
                                    ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'All',
                            label: Text('All'),
                          ),
                          ButtonSegment(
                            value: 'Active',
                            label: Text('Active'),
                          ),
                          ButtonSegment(
                            value: 'Done',
                            label: Text('Done'),
                          ),
                        ],
                        selected: {_filter},
                        onSelectionChanged: (value) {
                          setState(() {
                            _filter = value.first;
                          });
                        },
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Your tasks',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight:
                                        FontWeight.w800,
                                  ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Refresh tasks',
                            onPressed:
                                _loading ? null : _loadTasks,
                            icon: const Icon(
                              Icons.refresh_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              if (_loading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_error != null)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    10,
                    20,
                    110,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _ErrorState(
                      message: _error!,
                      onRetry: _loadTasks,
                    ),
                  ),
                )
              else if (visibleTasks.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    10,
                    20,
                    110,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _EmptyState(
                      hasFilters:
                          _filter != 'All' ||
                          _search.isNotEmpty,
                      onCreate: () => _openTaskForm(),
                      onClearFilters: () {
                        _searchController.clear();

                        setState(() {
                          _filter = 'All';
                          _search = '';
                        });
                      },
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    110,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final object =
                            visibleTasks[index];

                        final task =
                            TaskModel.fromParse(object);

                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: TaskCard(
                            task: task,
                            onToggle: () =>
                                _toggle(object),
                            onEdit: () =>
                                _openTaskForm(object),
                            onDelete: () =>
                                _delete(object),
                          ),
                        );
                      },
                      childCount: visibleTasks.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.hasFilters,
    required this.onCreate,
    required this.onClearFilters,
  });

  final bool hasFilters;
  final VoidCallback onCreate;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 36,
        ),
        child: Column(
          children: [
            Icon(
              hasFilters
                  ? Icons.search_off_rounded
                  : Icons.task_alt_rounded,
              size: 52,
              color:
                  Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters
                  ? 'No matching tasks'
                  : 'No tasks yet',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? 'Try changing your search or filter.'
                  : 'Create your first task to start planning your work.',
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            if (hasFilters)
              OutlinedButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(
                  Icons.filter_alt_off_rounded,
                ),
                label: const Text('Clear filters'),
              )
            else
              FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add_rounded),
                label:
                    const Text('Create first task'),
              ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 30,
        ),
        child: Column(
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: Theme.of(context)
                  .colorScheme
                  .error,
            ),
            const SizedBox(height: 14),
            Text(
              'Could not load tasks',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton.tonalIcon(
              onPressed: () => onRetry(),
              icon:
                  const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}