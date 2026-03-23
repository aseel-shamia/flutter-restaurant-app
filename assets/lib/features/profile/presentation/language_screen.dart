// lib/features/profile/presentation/language_screen.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLang = 'en';

  void _changeLanguage(String code) {
    setState(() => _selectedLang = code);

    // لو بدك تخليه يغيّر لغة التطبيق فعلاً:
    if (code == 'en') {
      context.setLocale(const Locale('en'));
    } else if (code == 'ar') {
      context.setLocale(const Locale('ar'));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Language changed to $code (demo)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('profile_language'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text(
            'Choose app language',
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
                RadioListTile<String>(
                  value: 'en',
                  groupValue: _selectedLang,
                  title: const Text('English'),
                  onChanged: (v) => _changeLanguage(v!),
                ),
                const Divider(height: 0),
                RadioListTile<String>(
                  value: 'ar',
                  groupValue: _selectedLang,
                  title: const Text('العربية'),
                  onChanged: (v) => _changeLanguage(v!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
