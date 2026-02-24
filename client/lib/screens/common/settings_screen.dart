import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/app_provider.dart';
import '../../core/providers/auth_provider.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.get('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              final user = authProvider.user;
              if (user == null) return const SizedBox();

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                        child: Text(
                          user.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        loc.get(user.role.toLowerCase()),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      if (user.phoneNumber != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          user.phoneNumber!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          textDirection: ui.TextDirection.ltr,
                        ),
                      ],
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms);
            },
          ),

          const SizedBox(height: 24),

          // Appearance Section
          Text(
            loc.get('appearance'),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.primaryColor,
            ),
          ),

          const SizedBox(height: 8),

          Consumer<AppProvider>(
            builder: (context, appProvider, _) {
              return Card(
                child: SwitchListTile(
                  secondary: Icon(
                    appProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  ),
                  title: Text(loc.get('darkMode')),
                  value: appProvider.isDarkMode,
                  onChanged: (_) => appProvider.toggleTheme(),
                ),
              );
            },
          ).animate().slideX(begin: -0.1, duration: 400.ms, delay: 100.ms),

          const SizedBox(height: 8),

          Consumer<AppProvider>(
            builder: (context, appProvider, _) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(loc.get('language')),
                  subtitle: Text(
                    appProvider.locale.languageCode == 'ar'
                        ? loc.get('arabic')
                        : loc.get('english'),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(loc.get('language')),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile<String>(
                              title: Text(loc.get('english')),
                              value: 'en',
                              groupValue: appProvider.locale.languageCode,
                              onChanged: (_) {
                                appProvider.setLocale(const Locale('en'));
                                Navigator.pop(context);
                              },
                            ),
                            RadioListTile<String>(
                              title: Text(loc.get('arabic')),
                              value: 'ar',
                              groupValue: appProvider.locale.languageCode,
                              onChanged: (_) {
                                appProvider.setLocale(const Locale('ar'));
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ).animate().slideX(begin: -0.1, duration: 400.ms, delay: 200.ms),

          const SizedBox(height: 24),

          // About Section
          Text(
            loc.get('about'),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.primaryColor,
            ),
          ),

          const SizedBox(height: 8),

          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(loc.get('aboutApp')),
              subtitle: Text('${loc.get('version')}: 1.0.2'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
          ).animate().slideX(begin: -0.1, duration: 400.ms, delay: 300.ms),

          const SizedBox(height: 32),

          // Logout Button
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(loc.get('logout')),
                        content: Text(loc.get('logoutConfirm')),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(loc.get('cancel')),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              authProvider.logout();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                            ),
                            child: Text(loc.get('logout')),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: Text(loc.get('logout')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error),
                  ),
                ),
              );
            },
          ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 400.ms),
        ],
      ),
    );
  }
}
