// lib/features/profile/presentation/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool pushEnabled = true;
  bool smsEnabled = false;
  bool emailEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('profile_notifications'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text(
            'Choose how you want to receive updates.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: cs.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: pushEnabled,
                  onChanged: (v) => setState(() => pushEnabled = v),
                  title: const Text('Push notifications'),
                  subtitle: const Text('Order status & promotions'),
                ),
                const Divider(height: 0),
                SwitchListTile(
                  value: smsEnabled,
                  onChanged: (v) => setState(() => smsEnabled = v),
                  title: const Text('SMS'),
                  subtitle: const Text('Important alerts & delivery info'),
                ),
                const Divider(height: 0),
                SwitchListTile(
                  value: emailEnabled,
                  onChanged: (v) => setState(() => emailEnabled = v),
                  title: const Text('Email'),
                  subtitle: const Text('News, offers and receipts'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
