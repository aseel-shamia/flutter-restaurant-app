import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'state/theme_notifier.dart';

/// Filled primary button (rounded, full-width)
class AppPrimaryButton extends StatelessWidget {
  final String labelKey;
  final VoidCallback onPressed;
  final double height;
  const AppPrimaryButton({
    super.key,
    required this.labelKey,
    required this.onPressed,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        child: Text(labelKey.tr(), style: TextStyle(fontSize: 14.5.sp)),
      ),
    );
  }
}

/// Outlined pill button (for “Continue with Google”)
class AppOutlineButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double height;
  const AppOutlineButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: height.h,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: cs.outlineVariant),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

/// Underline text field to match Figma
class AppUnderlineField extends StatelessWidget {
  final String labelKey;
  final bool obscure;
  final TextInputType? keyboard;
  final TextEditingController? controller;
  const AppUnderlineField({
    super.key,
    required this.labelKey,
    this.obscure = false,
    this.keyboard,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: labelKey.tr(),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
      ),
    );
  }
}

/// Top actions used in every AppBar (language + theme)
class AppTopActions extends StatelessWidget {
  const AppTopActions({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLang = context.locale.languageCode;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PopupMenuButton<Locale>(
          tooltip: 'language'.tr(),
          onSelected: (locale) => context.setLocale(locale),
          itemBuilder: (_) => [
            PopupMenuItem(
              value: const Locale('en'),
              child: Row(children: [
                if (currentLang == 'en') const Icon(Icons.check, size: 18),
                if (currentLang == 'en') const SizedBox(width: 6),
                const Text('EN'),
              ]),
            ),
            PopupMenuItem(
              value: const Locale('ar'),
              child: Row(children: [
                if (currentLang == 'ar') const Icon(Icons.check, size: 18),
                if (currentLang == 'ar') const SizedBox(width: 6),
                const Text('AR'),
              ]),
            ),
          ],
          icon: const Icon(Icons.language),
        ),
        IconButton(
          tooltip: 'theme'.tr(),
          icon: const Icon(Icons.brightness_6),
          onPressed: () => context.read<ThemeNotifier>().toggle(),
        ),
      ],
    );
  }
}
