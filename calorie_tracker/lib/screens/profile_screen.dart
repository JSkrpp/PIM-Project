import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calorie_tracker/state_contexts/calorie_goal.dart';
import 'package:calorie_tracker/state_contexts/app_theme.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedTheme = 'System default';

  void _showCalorieGoalDialog() {
    final provider = CalorieGoalProvider.of(context);
    int tempGoal = provider.goal;
    final controller = TextEditingController(text: tempGoal.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set calorie goal'),
        content: StatefulBuilder(
          builder: (context, setLocal) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                decoration: const InputDecoration(
                  labelText: 'Calories per day',
                  hintText: '500-10000',
                  suffixText: 'kcal',
                ),
                onChanged: (value) {
                  final parsed = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
                  if (parsed != null) setLocal(() => tempGoal = parsed.clamp(500, 10000));
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final parsed = int.tryParse(controller.text.replaceAll(RegExp(r'[^0-9]'), ''));
              if (parsed != null) {
                provider.setGoal(parsed.clamp(500, 10000));
              }
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showThemeSelector() {
    String tempSelection = _selectedTheme;
    final themeController = AppThemeProvider.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose theme'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  tempSelection == 'System default' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                ),
                title: const Text('System default'),
                onTap: () {
                  setState(() => tempSelection = 'System default');
                },
              ),
              ListTile(
                leading: Icon(
                  tempSelection == 'Light' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                ),
                title: const Text('Light'),
                onTap: () {
                  setState(() => tempSelection = 'Light');
                },
              ),
              ListTile(
                leading: Icon(
                  tempSelection == 'Dark' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                ),
                title: const Text('Dark'),
                onTap: () {
                  setState(() => tempSelection = 'Dark');
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() => _selectedTheme = tempSelection);
              switch (tempSelection) {
                case 'Light':
                  themeController.setMode(ThemeMode.light);
                  break;
                case 'Dark':
                  themeController.setMode(ThemeMode.dark);
                  break;
                default:
                  themeController.setMode(ThemeMode.system);
              }
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = Provider.of<User?>(context);

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.shade700,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: colorScheme.primary,
                    backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                    child: user?.photoURL == null
                        ? Icon(
                            Icons.person,
                            size: 64,
                            color: colorScheme.onPrimary,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? 'User',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user?.email ?? 'No email',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Material(
                  color: theme.colorScheme.surface,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 12),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          'Profile Settings',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.flag_outlined, color: colorScheme.onSurfaceVariant),
                        title: const Text('Calorie goal'),
                        subtitle: Text('${CalorieGoalProvider.of(context).goal} kcal/day'),
                        onTap: _showCalorieGoalDialog,
                      ),
                      Divider(height: 24, color: colorScheme.outlineVariant),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Text(
                          'App Settings',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.color_lens_outlined, color: colorScheme.onSurfaceVariant),
                        title: const Text('Theme'),
                        subtitle: Text(_selectedTheme),
                        onTap: _showThemeSelector,
                      ),
                      Divider(height: 24, color: colorScheme.outlineVariant),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                        child: Text(
                          'Account',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: colorScheme.error,
                        ),
                        title: const Text('Logout'),
                        titleTextStyle: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                        onTap: () async {
                          await context.read<AuthService>().signOut();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
