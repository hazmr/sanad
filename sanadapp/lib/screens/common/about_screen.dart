import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/localization/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String whatsappNumber = '+201009474831';
  static const String backendDeveloper = 'Hazem Helal';
  static const String flutterDeveloper = 'Sondos Amr';

  Future<void> _launchWhatsApp(BuildContext context) async {
    final Uri whatsappUrl = Uri.parse('https://wa.me/201009474831');
    
    try {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')),
        );
      }
    }
  }

  Future<void> _launchPhone(BuildContext context) async {
    final Uri phoneUrl = Uri.parse('tel:$whatsappNumber');
    
    try {
      await launchUrl(phoneUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not make call')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.get('aboutApp')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // App Info
            Text(
              loc.get('appName'),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 400.ms),
            
            const SizedBox(height: 4),
            
            Text(
              loc.get('appTagline'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            
            const SizedBox(height: 4),
            
            Text(
              '${loc.get('version')}: 1.0.1',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

            const SizedBox(height: 32),

            // Developers Section - Side by Side
            Text(
              loc.get('developedBy'),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.primaryColor,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

            const SizedBox(height: 16),

            // Developers Row
            Row(
              children: [
                // Backend Developer
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: theme.primaryColor.withOpacity(0.1),
                            child: Icon(
                              Icons.code,
                              color: theme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backendDeveloper,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            loc.get('backendDeveloper'),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Flutter Developer
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            child: const Icon(
                              Icons.phone_android,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            flutterDeveloper,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            loc.get('flutterDeveloper'),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ).animate().slideY(begin: 0.1, duration: 400.ms, delay: 400.ms),

            const SizedBox(height: 32),

            // Contact Section
            Text(
              loc.get('contactUs'),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.primaryColor,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 500.ms),

            const SizedBox(height: 8),

            Text(
              loc.get('subscribeMessage'),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 600.ms),

            const SizedBox(height: 16),

            // Phone Number
            Text(
              whatsappNumber,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
              textDirection: TextDirection.ltr,
            ).animate().fadeIn(duration: 400.ms, delay: 700.ms),

            const SizedBox(height: 24),

            // Action Buttons Row
            Row(
              children: [
                // Call Button
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () => _launchPhone(context),
                      icon: const Icon(Icons.phone_outlined, size: 20),
                      label: Text(loc.get('call')),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // WhatsApp Button
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchWhatsApp(context),
                      icon: const Icon(Icons.chat, size: 20),
                      label: const Text('WhatsApp'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 800.ms),
          ],
        ),
      ),
    );
  }
}
