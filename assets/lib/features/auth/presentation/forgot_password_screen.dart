import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../shared/responsive/sizes.dart';
import '../../../shared/state/theme_notifier.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final currentLang = context.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text('forgot_password'.tr()),
        centerTitle: true,
        actions: [
          // 🔀 زر تغيير اللغة
          PopupMenuButton<Locale>(
            tooltip: 'language'.tr(),
            onSelected: (locale) => context.setLocale(locale),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('en'),
                child: Row(
                  children: [
                    if (currentLang == 'en') const Icon(Icons.check, size: 18),
                    if (currentLang == 'en') const SizedBox(width: 6),
                    const Text('EN'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: const Locale('ar'),
                child: Row(
                  children: [
                    if (currentLang == 'ar') const Icon(Icons.check, size: 18),
                    if (currentLang == 'ar') const SizedBox(width: 6),
                    const Text('AR'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.language),
          ),

          // 🌙/☀️ زر تغيير الوضع (داكن ↔ فاتح)
          IconButton(
            tooltip: 'theme'.tr(),
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeNotifier>().toggle();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Insets.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Illustration or icon
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.center,
                child: Icon(Icons.lock_reset, size: 96.r, color: cs.primary),
              ),
              SizedBox(height: 16.h),

              // Title & description
              Text(
                'forgot_password_title'.tr(),
                style: t.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.h),
              Text(
                'forgot_password_desc'.tr(),
                style: t.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              // Email input
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'email'.tr(),
                  hintText: 'email'.tr(),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                ),
              ),
              SizedBox(height: 16.h),

              // Send reset button
              SizedBox(
                height: Heights.button,
                child: FilledButton(
                  onPressed: () {
                    // TODO: send reset email logic
                    // After success, navigate to a "reset email sent" screen
                    // e.g., context.go('/reset-sent');
                  },
                  child: Text(
                    'send_reset_link'.tr(),
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Back to sign in
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                icon: const Icon(Icons.arrow_back),
                label: Text('sign_in'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
