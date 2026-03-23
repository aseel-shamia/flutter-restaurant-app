import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../shared/state/theme_notifier.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _goIntro(BuildContext context) => context.go('/intro');

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final currentLang = context.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Image.asset('assets/images/g12.png', height: 24.h,
            errorBuilder: (_, __, ___) => const SizedBox.shrink()),
        actions: [
          PopupMenuButton<Locale>(
            tooltip: 'language'.tr(),
            icon: const Icon(Icons.language),
            onSelected: (l) => context.setLocale(l),
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
          ),
          IconButton(
            tooltip: 'theme'.tr(),
            icon: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeNotifier>().toggle(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // الدائرة الفاتحة أعلى اليسار
              SizedBox(height: 4.h),
              Stack(
                children: [
                  Positioned(
                    top: -110.h,
                    left: -110.w,
                    child: Container(
                      width: 380.r,
                      height: 380.r,
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/g12.png', height: 30.h,
                              errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                          SizedBox(width: 8.w),
                          Text(
                            'brand_title'.tr(), // "Tamang\nFoodService"
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // الـ Illustration
              Image.asset('assets/images/4.png', height: 260.h, fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.icecream, size: 120.r, color: cs.primary)),

              SizedBox(height: 20.h),
              Text('wt0_title'.tr(),
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700)),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  'wt0_body'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, height: 1.45, color: cs.onSurfaceVariant),
                ),
              ),
              SizedBox(height: 24.h),

              SizedBox(
                width: double.infinity, height: 48.h,
                child: FilledButton(
                  onPressed: () => _goIntro(context),
                  child: Text('get_started'.tr(), style: TextStyle(fontSize: 14.5.sp)),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
