import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/table_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/api_service.dart';
import '../../core/widgets/app_text_field.dart';

class EditTableScreen extends StatefulWidget {
  final int patientId;
  final TableModel? existingTable;

  const EditTableScreen({
    super.key,
    required this.patientId,
    this.existingTable,
  });

  @override
  State<EditTableScreen> createState() => _EditTableScreenState();
}

class _EditTableScreenState extends State<EditTableScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tableNameController = TextEditingController();
  final List<TextEditingController> _checkTaskControllers = [];
  final List<TextEditingController> _questionTaskControllers = [];
  
  List<CheckTaskModel> _checkTasks = [];
  List<QuestionTaskModel> _questionTasks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingTable != null) {
      _tableNameController.text = widget.existingTable!.name;
      _checkTasks = List.from(widget.existingTable!.checkTasks);
      _questionTasks = List.from(widget.existingTable!.questionTasks);
      
      for (var task in _checkTasks) {
        _checkTaskControllers.add(TextEditingController(text: task.label));
      }
      for (var task in _questionTasks) {
        _questionTaskControllers.add(TextEditingController(text: task.label));
      }
    }
  }

  @override
  void dispose() {
    _tableNameController.dispose();
    for (var controller in _checkTaskControllers) {
      controller.dispose();
    }
    for (var controller in _questionTaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addCheckTask() {
    setState(() {
      _checkTaskControllers.add(TextEditingController());
    });
  }

  void _removeCheckTask(int index) {
    setState(() {
      _checkTaskControllers[index].dispose();
      _checkTaskControllers.removeAt(index);
      if (index < _checkTasks.length) {
        _checkTasks.removeAt(index);
      }
    });
  }

  void _addQuestionTask() {
    setState(() {
      _questionTaskControllers.add(TextEditingController());
    });
  }

  void _removeQuestionTask(int index) {
    setState(() {
      _questionTaskControllers[index].dispose();
      _questionTaskControllers.removeAt(index);
      if (index < _questionTasks.length) {
        _questionTasks.removeAt(index);
      }
    });
  }

  Future<void> _saveTable() async {
    if (_formKey.currentState!.validate()) {
      if (_checkTaskControllers.isEmpty && _questionTaskControllers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add at least one task')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final authProvider = context.read<AuthProvider>();
        final apiService = ApiService(authProvider: authProvider);

        TableModel? result;

        if (widget.existingTable == null) {
          // Create new table
          result = await apiService.createPatientTable(
            widget.patientId,
            _tableNameController.text.trim(),
            _checkTaskControllers
                .where((c) => c.text.trim().isNotEmpty)
                .map((c) => c.text.trim())
                .toList(),
            _questionTaskControllers
                .where((c) => c.text.trim().isNotEmpty)
                .map((c) => c.text.trim())
                .toList(),
          );
        } else {
          // Update existing table
          final checkTasks = List.generate(_checkTaskControllers.length, (i) {
            return {
              'id': i < _checkTasks.length ? _checkTasks[i].id : null,
              'taskId': i < _checkTasks.length ? _checkTasks[i].taskId : null,
              'label': _checkTaskControllers[i].text.trim(),
              'isActive': true,
            };
          });

          final questionTasks = List.generate(_questionTaskControllers.length, (i) {
            return {
              'id': i < _questionTasks.length ? _questionTasks[i].id : null,
              'taskId': i < _questionTasks.length ? _questionTasks[i].taskId : null,
              'label': _questionTaskControllers[i].text.trim(),
              'isActive': true,
            };
          });

          result = await apiService.updatePatientTable(
            widget.patientId,
            _tableNameController.text.trim(),
            checkTasks,
            questionTasks,
          );
        }

        if (!mounted) return;

        if (result != null) {
          final loc = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.get('success'))),
          );
          Navigator.pop(context, true);
        } else {
          throw Exception('Failed to save table');
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isEdit = widget.existingTable != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? loc.get('editTable') : loc.get('createTable')),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveTable,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Table Name
            AppTextField(
              controller: _tableNameController,
              type: AppTextFieldType.text,
              labelText: loc.get('tableName'),
              prefixIcon: Icons.table_chart,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return loc.get('tableName');
                }
                return null;
              },
            ).animate().slideY(begin: 0.2, duration: 400.ms),

            const SizedBox(height: 32),

            // Check Tasks Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loc.get('checkTasks'),
                  style: theme.textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: _addCheckTask,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(loc.get('add')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ..._checkTaskControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: controller,
                          type: AppTextFieldType.text,
                          hintText: loc.get('taskLabel'),
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return loc.get('taskLabel');
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _removeCheckTask(index),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms);
            }),

            if (_checkTaskControllers.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No check tasks yet',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 32),

            // Question Tasks Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loc.get('questionTasks'),
                  style: theme.textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: _addQuestionTask,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(loc.get('add')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ..._questionTaskControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: controller,
                          type: AppTextFieldType.text,
                          hintText: loc.get('taskLabel'),
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return loc.get('taskLabel');
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _removeQuestionTask(index),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms);
            }),

            if (_questionTaskControllers.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No question tasks yet',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveTable,
                child: Text(
                  loc.get('save'),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
