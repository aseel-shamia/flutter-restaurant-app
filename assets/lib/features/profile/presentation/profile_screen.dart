// lib/features/profile/presentation/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ← تسجيل الخروج

import '../../../app/app_routes.dart';
import '../../home/widgets/app_bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('profile_title'.tr()), // Profile
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====== معلومات المستخدم ======
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: cs.primary.withOpacity(0.15),
                    child: Text(
                      'MA',
                      style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'profile_name'.tr(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'profile_email'.tr(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 24),

              // ====== ACCOUNT ======
              Text(
                'profile_section_account'.tr(),
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
                    _ProfileTile(
                      icon: Icons.person_outline,
                      title: 'profile_edit_account'.tr(),
                      subtitle: 'profile_edit_account_sub'.tr(),
                      onTap: () {
                        context.pushNamed(AppRoutes.nEditAccount);
                      },
                    ),
                    const Divider(height: 0),
                    _ProfileTile(
                      icon: Icons.location_on_outlined,
                      title: 'profile_addresses'.tr(),
                      subtitle: 'profile_addresses_sub'.tr(),
                      onTap: () {
                        context.pushNamed(AppRoutes.nDeliveryAddresses);
                      },
                    ),
                    const Divider(height: 0),
                    _ProfileTile(
                      icon: Icons.payment_outlined,
                      title: 'profile_payment_methods'.tr(),
                      subtitle: 'profile_payment_methods_sub'.tr(),
                      onTap: () {
                        context.pushNamed(AppRoutes.nPaymentMethods);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ====== SETTINGS ======
              Text(
                'profile_section_settings'.tr(),
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
                    _ProfileTile(
                      icon: Icons.notifications_none,
                      title: 'profile_notifications'.tr(),
                      subtitle: 'profile_notifications_sub'.tr(),
                      onTap: () {
                        context.pushNamed(AppRoutes.nNotifications);
                      },
                    ),
                    const Divider(height: 0),
                    _ProfileTile(
                      icon: Icons.language,
                      title: 'profile_language'.tr(),
                      subtitle: 'profile_language_sub'.tr(),
                      onTap: () {
                        context.pushNamed(AppRoutes.nLanguage);
                      },
                    ),
                    const Divider(height: 0),
                    _ProfileTile(
                      icon: Icons.shield_outlined,
                      title: 'profile_privacy'.tr(),
                      subtitle: 'profile_privacy_sub'.tr(),
                      onTap: () {
                        context.pushNamed(AppRoutes.nPrivacySecurity);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ====== LOG OUT ======
              Card(
                elevation: 0,
                color: cs.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _ProfileTile(
                  icon: Icons.logout,
                  iconColor: Colors.redAccent,
                  title: 'profile_logout'.tr(),
                  titleColor: Colors.redAccent,
                  onTap: () async {
                    // تسجيل الخروج من Firebase
                    await FirebaseAuth.instance.signOut();

                    // رسالة بسيطة
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out')),
                    );

                    // الانتقال لشاشة تسجيل الدخول
                    context.goNamed(AppRoutes.nSignin);
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }
}

/// عنصر واحد (ListTile)
class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final Color? titleColor;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? cs.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? cs.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
        subtitle!,
        style: TextStyle(
          color: cs.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
