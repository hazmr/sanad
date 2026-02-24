import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/api_service.dart';
import '../../core/widgets/app_text_field.dart';

class RegisterPatientScreen extends StatefulWidget {
  const RegisterPatientScreen({super.key});

  @override
  State<RegisterPatientScreen> createState() => _RegisterPatientScreenState();
}

class _RegisterPatientScreenState extends State<RegisterPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final authProvider = context.read<AuthProvider>();
        final apiService = ApiService(authProvider: authProvider);

        final result = await apiService.registerPatient(
          _nameController.text.trim(),
          _phoneController.text.trim(),
          _passwordController.text,
        );

        if (!mounted) return;

        if (result != null) {
          final loc = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.get('patientRegistered'))),
          );
          Navigator.pop(context, true);
        } else {
          throw Exception('Failed to register patient');
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

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.get('addPatient')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.person_add_rounded,
                size: 80,
                color: theme.primaryColor.withValues(alpha: 0.8),
              ).animate().scale(duration: 600.ms),
              
              const SizedBox(height: 32),
              
              AppTextField.name(
                controller: _nameController,
                labelText: loc.get('patientName'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.get('patientName');
                  }
                  return null;
                },
              ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 200.ms),
              
              const SizedBox(height: 16),
              
              AppTextField.phone(
                controller: _phoneController,
                labelText: loc.get('phoneNumber'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.get('phoneNumber');
                  }
                  return null;
                },
              ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 300.ms),
              
              const SizedBox(height: 16),
              
              AppTextField.password(
                controller: _passwordController,
                labelText: loc.get('password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.get('password');
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 400.ms),
              
              const SizedBox(height: 32),
              
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
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
