import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/table_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/api_service.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late ApiService _apiService;
  TableModel? _table;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _apiService = ApiService(authProvider: authProvider);
    _loadTable();
  }

  Future<void> _loadTable() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final table = await _apiService.getPatientTable();
      setState(() {
        _table = table;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateCheckTask(CheckTaskModel task, bool value) async {
    try {
      final success = await _apiService.updateCheckTask(task.id, value);
      if (success) {
        setState(() {
          final index = _table!.checkTasks.indexWhere((t) => t.id == task.id);
          _table!.checkTasks[index] = task.copyWith(value: value);
        });

        if (mounted) {
          final loc = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.get('taskCompleted')),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _updateQuestionTask(QuestionTaskModel task, String? answer) async {
    try {
      final success = await _apiService.updateQuestionTask(task.id, answer);
      if (success) {
        setState(() {
          final index = _table!.questionTasks.indexWhere((t) => t.id == task.id);
          _table!.questionTasks[index] = task.copyWith(answer: answer);
        });

        if (mounted) {
          final loc = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.get('success')),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showQuestionDialog(QuestionTaskModel task) {
    final controller = TextEditingController(text: task.answer);
    final loc = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.label),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: loc.get('answerPlaceholder'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateQuestionTask(task, controller.text);
            },
            child: Text(loc.get('save')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.get('dailyTasks')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTable,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                      const SizedBox(height: 16),
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadTable,
                        icon: const Icon(Icons.refresh),
                        label: Text(loc.get('retry')),
                      ),
                    ],
                  ),
                )
              : _table == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 80,
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            loc.get('noTasks'),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadTable,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Progress Card
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        loc.get('todayProgress'),
                                        style: theme.textTheme.titleLarge,
                                      ),
                                      Text(
                                        '${(_table!.progress * 100).toInt()}%',
                                        style: theme.textTheme.titleLarge?.copyWith(
                                          color: theme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: _table!.progress,
                                      minHeight: 8,
                                      backgroundColor: theme.colorScheme.surface,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      _buildStatChip(
                                        loc.get('completed'),
                                        _table!.completedTasks.toString(),
                                        theme.colorScheme.secondary,
                                      ),
                                      const SizedBox(width: 8),
                                      _buildStatChip(
                                        loc.get('remaining'),
                                        (_table!.totalTasks - _table!.completedTasks).toString(),
                                        theme.colorScheme.error,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),

                          const SizedBox(height: 24),

                          // Check Tasks
                          if (_table!.checkTasks.where((t) => t.isActive).isNotEmpty) ...[
                            Text(
                              loc.get('checkTasks'),
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            ..._table!.checkTasks
                                .where((t) => t.isActive)
                                .map((task) => Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: CheckboxListTile(
                                        value: task.value,
                                        onChanged: (value) {
                                          if (value != null) {
                                            _updateCheckTask(task, value);
                                          }
                                        },
                                        title: Text(task.label),
                                        controlAffinity: ListTileControlAffinity.leading,
                                      ),
                                    ))
                                .toList()
                                .animate(interval: 50.ms)
                                .fadeIn(duration: 300.ms)
                                .slideX(begin: -0.1),
                            const SizedBox(height: 24),
                          ],

                          // Question Tasks
                          if (_table!.questionTasks.where((t) => t.isActive).isNotEmpty) ...[
                            Text(
                              loc.get('questionTasks'),
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            ..._table!.questionTasks
                                .where((t) => t.isActive)
                                .map((task) => Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: ListTile(
                                        title: Text(task.label),
                                        subtitle: task.answer != null && task.answer!.isNotEmpty
                                            ? Text(
                                                task.answer!,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : null,
                                        trailing: Icon(
                                          task.answer != null && task.answer!.isNotEmpty
                                              ? Icons.check_circle
                                              : Icons.edit_outlined,
                                          color: task.answer != null && task.answer!.isNotEmpty
                                              ? theme.colorScheme.secondary
                                              : theme.colorScheme.onSurface.withOpacity(0.5),
                                        ),
                                        onTap: () => _showQuestionDialog(task),
                                      ),
                                    ))
                                .toList()
                                .animate(interval: 50.ms)
                                .fadeIn(duration: 300.ms)
                                .slideX(begin: -0.1),
                          ],
                        ],
                      ),
                    ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
