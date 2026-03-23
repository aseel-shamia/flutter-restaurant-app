import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    // simple pop-in animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    // navigate after a short delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) context.go('/walkthrough');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final currentLang = context.locale.languageCode;

    return Scaffold(
      backgroundColor: cs.primaryContainer,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // logo (بدّله بصورة شعارك إن وجدت)
                // Image.asset('assets/images/g12.png', height: 96.h),
                Icon(Icons.fastfood, size: 96.r, color: cs.primary),
                SizedBox(height: 16.h),

                // app name
                Text(
                  'app_name'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: cs.onPrimaryContainer,
                  ),
                ),
                SizedBox(height: 8.h),

                // tagline
                Text(
                  'welcome_hint'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: cs.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 20.h),

                // ===== Language toggle (EN / AR) =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => context.setLocale(const Locale('en')),
                      child: Text(
                        'EN',
                        style: TextStyle(
                          fontWeight:
                          currentLang == 'en' ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.setLocale(const Locale('ar')),
                      child: Text(
                        'AR',
                        style: TextStyle(
                          fontWeight:
                          currentLang == 'ar' ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
