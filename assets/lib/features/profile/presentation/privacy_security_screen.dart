// lib/features/profile/presentation/privacy_security_screen.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool locationAllowed = true;
  bool trackingAllowed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('profile_privacy'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text(
            'Permissions',
            style: theme.textTheme.labelLarge?.copyWith(
              color: cs.onSurfaceVariant,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: cs.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: locationAllowed,
                  onChanged: (v) => setState(() => locationAllowed = v),
                  title: const Text('Location access'),
                  subtitle: const Text('Allow app to use your location'),
                ),
                const Divider(height: 0),
                SwitchListTile(
                  value: trackingAllowed,
                  onChanged: (v) => setState(() => trackingAllowed = v),
                  title: const Text('Usage analytics'),
                  subtitle: const Text('Help us improve the app'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Privacy',
            style: theme.textTheme.labelLarge?.copyWith(
              color: cs.onSurfaceVariant,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: cs.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.description_outlined),
                  title: Text('Privacy policy'),
                  subtitle: Text('View how we use and store your data'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(height: 0),
                ListTile(
                  leading: Icon(Icons.rule_folder_outlined),
                  title: Text('Terms of service'),
                  subtitle: Text('Read app terms and conditions'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
