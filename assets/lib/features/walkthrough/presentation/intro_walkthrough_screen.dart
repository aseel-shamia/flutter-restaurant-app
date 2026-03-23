// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../shared/state/theme_notifier.dart';

class IntroWalkthroughScreen extends StatefulWidget {
  const IntroWalkthroughScreen({super.key});

  @override
  State<IntroWalkthroughScreen> createState() => _IntroWalkthroughScreenState();
}

class _IntroWalkthroughScreenState extends State<IntroWalkthroughScreen> {
  final _ctrl = PageController();
  int _index = 0;

  void _finish() => context.go('/signin');

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

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
            icon: const Icon(Icons.language),
          ),
          IconButton(
            tooltip: 'theme'.tr(),
            icon: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeNotifier>().toggle(),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _ctrl,
                  onPageChanged: (i) => setState(() => _index = i),
                  children: [
                    _IllustratedSlide(
                      imagePath: 'assets/images/illustration (1).png',
                      titleKey: 'wt1_title',
                      bodyKey: 'wt1_body',
                    ),
                    _IllustratedSlide(
                      imagePath: 'assets/images/illustration (2).png',
                      titleKey: 'wt2_title',
                      bodyKey: 'wt2_body',
                    ),
                    _IllustratedSlide(
                      imagePath: 'assets/images/2.png',
                      titleKey: 'wt3_title',
                      bodyKey: 'wt3_body',
                    ),
                  ],
                ),
              ),

              // Dots
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final active = _index == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    height: 8.r,
                    width: active ? 22.w : 8.r,
                    decoration: BoxDecoration(
                      color: active ? cs.primary : cs.outlineVariant,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  );
                }),
              ),
              SizedBox(height: 16.h),

              // CTA
              SafeArea(
                minimum: EdgeInsets.only(bottom: 12.h),
                child: SizedBox(
                  width: double.infinity, height: 48.h,
                  child: FilledButton(
                    onPressed: () {
                      if (_index < 2) {
                        _ctrl.nextPage(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOut,
                        );
                      } else {
                        _finish();
                      }
                    },
                    child: Text(
                      _index < 2 ? 'next'.tr() : 'get_started'.tr(),
                      style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// عنصر السلايد الواحد
class _IllustratedSlide extends StatelessWidget {
  final String imagePath, titleKey, bodyKey;
  const _IllustratedSlide({
    required this.imagePath,
    required this.titleKey,
    required this.bodyKey,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // دائرة باهتة خلف الرسمة
        Positioned(
          top: 38.h, left: 0, right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 230.r, height: 230.r,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),

        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/g12.png', height: 26.h,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                  SizedBox(width: 6.w),
                  Text(
                    'brand_title'.tr(),
                    style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800, height: 1),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Image.asset(
                imagePath, height: 220.h, fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.fastfood, size: 120.r, color: cs.primary),
              ),
              SizedBox(height: 18.h),
              Text(titleKey.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  bodyKey.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: cs.onSurfaceVariant, height: 1.4),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ],
    );
  }
}
