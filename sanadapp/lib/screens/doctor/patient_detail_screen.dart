import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/patient_model.dart';
import '../../core/models/table_model.dart';
import '../../core/models/history_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/api_service.dart';
import 'edit_table_screen.dart';
import 'edit_patient_screen.dart';

class PatientDetailScreen extends StatefulWidget {
  final PatientModel patient;

  const PatientDetailScreen({super.key, required this.patient});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen>
    with SingleTickerProviderStateMixin {
  late ApiService _apiService;
  late TabController _tabController;
  late PatientModel _patient;
  
  TableModel? _table;
  List<TaskHistoryModel> _history = [];
  bool _isLoadingTable = true;
  bool _isLoadingHistory = true;
  String? _errorTable;
  String? _errorHistory;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _apiService = ApiService(authProvider: authProvider);
    _patient = widget.patient;
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    _loadTable();
    _loadHistory();
  }

  Future<void> _loadTable() async {
    setState(() {
      _isLoadingTable = true;
      _errorTable = null;
    });

    try {
      final table = await _apiService.getPatientTableByDoctor(widget.patient.id);
      setState(() {
        _table = table;
        _isLoadingTable = false;
      });
    } catch (e) {
      setState(() {
        _errorTable = e.toString();
        _isLoadingTable = false;
      });
    }
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoadingHistory = true;
      _errorHistory = null;
    });

    try {
      final history = await _apiService.getPatientHistoryByDoctor(widget.patient.id);
      setState(() {
        _history = history;
        _isLoadingHistory = false;
      });
    } catch (e) {
      setState(() {
        _errorHistory = e.toString();
        _isLoadingHistory = false;
      });
    }
  }

  void _navigateToEditTable() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTableScreen(
          patientId: _patient.id,
          existingTable: _table,
        ),
      ),
    ).then((_) => _loadTable());
  }

  void _navigateToEditPatient() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (context) => EditPatientScreen(patient: _patient),
      ),
    ).then((result) {
      if (!mounted) return;
      if (result == 'deleted') {
        Navigator.pop(context);
      } else if (result is PatientModel) {
        // Patient was updated, update local state
        setState(() {
          _patient = result;
        });
      }
    });
  }

  void _showHistoryDetails(TaskHistoryModel history) {
    final loc = AppLocalizations.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    DateFormat.yMMMd().format(history.date),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  if (history.checkTasks.isNotEmpty) ...[
                    Text(
                      loc.get('checkTasks'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...history.checkTasks.map((task) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(
                              task.value ? Icons.check_circle : Icons.cancel,
                              color: task.value
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.error,
                            ),
                            title: Text(task.label),
                          ),
                        )),
                    const SizedBox(height: 16),
                  ],
                  if (history.questionTasks.isNotEmpty) ...[
                    Text(
                      loc.get('questionTasks'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...history.questionTasks.map((task) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(task.label),
                            subtitle: task.answer != null && task.answer!.isNotEmpty
                                ? Text(task.answer!)
                                : Text(
                                    loc.get('noData'),
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_patient.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _navigateToEditPatient,
            tooltip: loc.get('editPatient'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: loc.get('tasks')),
            Tab(text: loc.get('history')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tasks Tab
          _buildTasksTab(loc, theme),
          
          // History Tab
          _buildHistoryTab(loc, theme),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _navigateToEditTable,
              icon: Icon(_table == null ? Icons.add : Icons.edit),
              label: Text(_table == null ? loc.get('createTable') : loc.get('editTable')),
            )
          : null,
    );
  }

  Widget _buildTasksTab(AppLocalizations loc, ThemeData theme) {
    if (_isLoadingTable) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorTable != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(_errorTable!),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadTable,
              icon: const Icon(Icons.refresh),
              label: Text(loc.get('retry')),
            ),
          ],
        ),
      );
    }

    if (_table == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 80,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              loc.get('noTasks'),
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
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
                  Text(
                    _table!.name,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.get('todayProgress'),
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(_table!.progress * 100).toInt()}%',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${_table!.completedTasks}/${_table!.totalTasks}',
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 24),

          // Check Tasks
          if (_table!.checkTasks.isNotEmpty) ...[
            Text(
              loc.get('checkTasks'),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ..._table!.checkTasks.map((task) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      task.value ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: task.value ? theme.colorScheme.secondary : null,
                    ),
                    title: Text(task.label),
                    trailing: task.isActive
                        ? null
                        : Chip(
                            label: Text('Inactive', style: TextStyle(fontSize: 10)),
                            visualDensity: VisualDensity.compact,
                          ),
                  ),
                )),
            const SizedBox(height: 24),
          ],

          // Question Tasks
          if (_table!.questionTasks.isNotEmpty) ...[
            Text(
              loc.get('questionTasks'),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ..._table!.questionTasks.map((task) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(task.label),
                    subtitle: task.answer != null && task.answer!.isNotEmpty
                        ? Text(task.answer!, maxLines: 2, overflow: TextOverflow.ellipsis)
                        : null,
                    trailing: task.isActive
                        ? Icon(
                            task.answer != null && task.answer!.isNotEmpty
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: task.answer != null && task.answer!.isNotEmpty
                                ? theme.colorScheme.secondary
                                : null,
                          )
                        : Chip(
                            label: Text('Inactive', style: TextStyle(fontSize: 10)),
                            visualDensity: VisualDensity.compact,
                          ),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildHistoryTab(AppLocalizations loc, ThemeData theme) {
    if (_isLoadingHistory) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorHistory != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(_errorHistory!),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadHistory,
              icon: const Icon(Icons.refresh),
              label: Text(loc.get('retry')),
            ),
          ],
        ),
      );
    }

    if (_history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_outlined,
              size: 80,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              loc.get('noHistory'),
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final history = _history[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                child: Icon(
                  Icons.calendar_today,
                  color: theme.primaryColor,
                  size: 20,
                ),
              ),
              title: Text(DateFormat.yMMMd().format(history.date)),
              subtitle: Text(
                '${history.completedCheckTasks}/${history.checkTasks.length} ${loc.get('checkTasks')} • '
                '${history.answeredQuestions}/${history.questionTasks.length} ${loc.get('questionTasks')}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showHistoryDetails(history),
            ),
          ).animate(delay: (index * 50).ms).fadeIn(duration: 300.ms);
        },
      ),
    );
  }
}
