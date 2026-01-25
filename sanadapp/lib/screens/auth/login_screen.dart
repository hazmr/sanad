import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/auth_provider.dart';
import '../common/about_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.login(
        _phoneController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (!success) {
        final loc = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? loc.get('invalidCredentials')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isArabic = loc.isArabic;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Name
                  Text(
                    loc.get('appName'),
                    style: theme.textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                  
                  const SizedBox(height: 8),
                  
                  // Tagline
                  Text(
                    loc.get('appTagline'),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                  
                  const SizedBox(height: 48),
                  
                  // Welcome Back
                  Text(
                    loc.get('welcomeBack'),
                    style: theme.textTheme.headlineSmall,
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  ).animate().slideX(
                    begin: isArabic ? 0.2 : -0.2,
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    loc.get('loginSubtitle'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                  
                  const SizedBox(height: 32),
                  
                  // Phone Number Field
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      labelText: loc.get('phoneNumber'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return loc.get('phoneNumber');
                      }
                      return null;
                    },
                  ).animate().slideY(
                    begin: 0.2,
                    duration: 600.ms,
                    delay: 300.ms,
                    curve: Curves.easeOut,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Password Field
                  ListenableBuilder(
                    listenable: _passwordController,
                    builder: (context, _) {
                      return TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          labelText: loc.get('password'),
                          suffixIcon: _passwordController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                )
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return loc.get('password');
                          }
                          return null;
                        },
                      );
                    },
                  ).animate().slideY(
                    begin: 0.2,
                    duration: 600.ms,
                    delay: 400.ms,
                    curve: Curves.easeOut,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Login Button
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      final isLoading = authProvider.state == AuthState.loading;
                      
                      return SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  loc.get('login'),
                                  style: const TextStyle(fontSize: 16),
                                ),
                        ),
                      );
                    },
                  ).animate().slideY(
                    begin: 0.2,
                    duration: 600.ms,
                    delay: 500.ms,
                    curve: Curves.easeOut,
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Need Help Link
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutScreen()),
                      );
                    },
                    child: Text(
                      loc.get('needHelp'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
