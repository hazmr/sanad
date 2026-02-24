import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/patient_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/api_service.dart';
import '../../core/widgets/app_text_field.dart';
import 'patient_detail_screen.dart';
import 'register_patient_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  late ApiService _apiService;
  final TextEditingController _searchController = TextEditingController();
  List<PatientModel> _patients = [];
  List<PatientModel> _searchResults = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _error;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _apiService = ApiService(authProvider: authProvider);
    _loadPatients();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(_searchController.text);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final results = await _apiService.searchPatients(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  Future<void> _loadPatients() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final patients = await _apiService.getDoctorPatients();
      setState(() {
        _patients = patients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _navigateToPatientDetail(PatientModel patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailScreen(patient: patient),
      ),
    ).then((_) => _loadPatients());
  }

  void _navigateToRegisterPatient() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPatientScreen(),
      ),
    ).then((result) {
      if (result == true) {
        _loadPatients();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final bool hasSearchQuery = _searchController.text.isNotEmpty;
    final displayPatients = hasSearchQuery ? _searchResults : _patients;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.get('myPatients')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPatients,
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
                        onPressed: _loadPatients,
                        icon: const Icon(Icons.refresh),
                        label: Text(loc.get('retry')),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: AppSimpleTextField.search(
                        controller: _searchController,
                        hintText: loc.get('searchPatients'),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchResults = [];
                                  });
                                },
                              )
                            : _isSearching
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  )
                                : null,
                      ),
                    ),
                    // Results
                    Expanded(
                      child: _patients.isEmpty && !hasSearchQuery
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 80,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    loc.get('noPatients'),
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : displayPatients.isEmpty && hasSearchQuery
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 80,
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        loc.get('noSearchResults'),
                                        style: theme.textTheme.titleLarge?.copyWith(
                                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: _loadPatients,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    itemCount: displayPatients.length,
                                    itemBuilder: (context, index) {
                                      final patient = displayPatients[index];
                                      return Card(
                                        margin: const EdgeInsets.only(bottom: 12),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                                            child: Text(
                                              patient.name.substring(0, 1).toUpperCase(),
                                              style: TextStyle(
                                                color: theme.primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          title: Text(patient.name),
                                          subtitle: Text(patient.phoneNumber ?? ''),
                                          trailing: const Icon(Icons.chevron_right),
                                          onTap: () => _navigateToPatientDetail(patient),
                                        ),
                                      ).animate(delay: (index * 50).ms).fadeIn(duration: 300.ms).slideX(begin: -0.1);
                                    },
                                  ),
                                ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToRegisterPatient,
        icon: const Icon(Icons.add),
        label: Text(loc.get('addPatient')),
      ),
    );
  }
}
