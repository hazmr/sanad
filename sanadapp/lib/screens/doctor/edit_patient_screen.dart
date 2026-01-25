import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/patient_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/api_service.dart';

class EditPatientScreen extends StatefulWidget {
  final PatientModel patient;

  const EditPatientScreen({super.key, required this.patient});

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _changePassword = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient.name);
    _phoneController = TextEditingController(text: widget.patient.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final authProvider = context.read<AuthProvider>();
        final apiService = ApiService(authProvider: authProvider);

        final result = await apiService.updatePatient(
          widget.patient.id,
          _nameController.text.trim(),
          _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
          _changePassword && _passwordController.text.isNotEmpty 
              ? _passwordController.text 
              : null,
        );

        if (!mounted) return;

        if (result != null) {
          final loc = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.get('patientUpdated'))),
          );
          // Return updated patient model
          final updatedPatient = PatientModel(
            id: widget.patient.id,
            name: _nameController.text.trim(),
            phoneNumber: _phoneController.text.trim().isNotEmpty 
                ? _phoneController.text.trim() 
                : widget.patient.phoneNumber,
            createdAt: widget.patient.createdAt,
          );
          Navigator.pop(context, updatedPatient);
        } else {
          throw Exception('Failed to update patient');
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

  Future<void> _handleDelete() async {
    final loc = AppLocalizations.of(context);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.get('deletePatient')),
        content: Text(loc.get('deletePatientConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.get('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(loc.get('delete')),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final apiService = ApiService(authProvider: authProvider);

      final success = await apiService.deletePatient(widget.patient.id);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.get('patientDeleted'))),
        );
        Navigator.pop(context, 'deleted');
      } else {
        throw Exception('Failed to delete patient');
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.get('editPatient')),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _isLoading ? null : _handleDelete,
            color: theme.colorScheme.error,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.person_outline,
                size: 80,
                color: theme.primaryColor.withValues(alpha: 0.8),
              ).animate().scale(duration: 600.ms),
              
              const SizedBox(height: 32),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: loc.get('patientName'),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.get('patientName');
                  }
                  return null;
                },
              ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 200.ms),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: loc.get('phoneNumber'),
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
              ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 300.ms),
              
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: Text(loc.get('changePassword')),
                value: _changePassword,
                onChanged: (value) {
                  setState(() {
                    _changePassword = value;
                    if (!value) {
                      _passwordController.clear();
                    }
                  });
                },
              ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 350.ms),
              
              if (_changePassword) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: loc.get('newPassword'),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (_changePassword && (value == null || value.isEmpty)) {
                      return loc.get('newPassword');
                    }
                    if (_changePassword && value != null && value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ).animate().slideY(begin: 0.2, duration: 400.ms),
              ],
              
              const SizedBox(height: 32),
              
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          loc.get('save'),
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
