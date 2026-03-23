// // lib/features/walkthrough/presentation/walkthrough_screen.dart
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:provider/provider.dart';
// import '../../../shared/state/theme_notifier.dart';
//
// class WalkthroughScreen extends StatelessWidget {
//   const WalkthroughScreen({super.key});
//
//   void _goSignIn(BuildContext context) => context.go('/signin');
//
//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     final currentLang = context.locale.languageCode;
//
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         centerTitle: true,
//         title: Image.asset(
//           'assets/images/g12.png',           // app mark (small, top)
//           height: 24.h,
//           errorBuilder: (_, __, ___) => const SizedBox.shrink(),
//         ),
//         actions: [
//           // language switch
//           PopupMenuButton<Locale>(
//             tooltip: 'language'.tr(),
//             onSelected: (l) => context.setLocale(l),
//             itemBuilder: (_) => [
//               PopupMenuItem(
//                 value: const Locale('en'),
//                 child: Row(children: [
//                   if (currentLang == 'en') const Icon(Icons.check, size: 18),
//                   if (currentLang == 'en') const SizedBox(width: 6),
//                   const Text('EN'),
//                 ]),
//               ),
//               PopupMenuItem(
//                 value: const Locale('ar'),
//                 child: Row(children: [
//                   if (currentLang == 'ar') const Icon(Icons.check, size: 18),
//                   if (currentLang == 'ar') const SizedBox(width: 6),
//                   const Text('AR'),
//                 ]),
//               ),
//             ],
//             icon: const Icon(Icons.language),
//           ),
//           // theme toggle
//           IconButton(
//             tooltip: 'theme'.tr(),
//             icon: const Icon(Icons.brightness_6),
//             onPressed: () => context.read<ThemeNotifier>().toggle(),
//           ),
//         ],
//       ),
//
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // pale circle at top-left (like Figma)
//               SizedBox(height: 4.h),
//               Stack(
//                 children: [
//                   Positioned(
//                     top: -110.h,
//                     left: -110.w,
//                     child: Container(
//                       width: 380.r,
//                       height: 380.r,
//                       decoration: BoxDecoration(
//                         color: cs.primary.withOpacity(0.08),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//                   // big brand title at top-left (two lines)
//                   Padding(
//                     padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h),
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Image.asset('assets/images/g12.png', height: 30.h,
//                             errorBuilder: (_, __, ___) => const SizedBox.shrink(),
//                           ),
//                           SizedBox(width: 8.w),
//                           Text(
//                             'brand_title'.tr(), // "Tamang\nFoodService"
//                             textAlign: TextAlign.start,
//                             style: TextStyle(
//                               fontSize: 30.sp,
//                               fontWeight: FontWeight.w800,
//                               height: 1.0,
//                               letterSpacing: -0.2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               // center illustration
//               SizedBox(height: 8.h),
//               Image.asset(
//                 'assets/images/4.png',         // <= you said this is the center image
//                 height: 260.h,
//                 fit: BoxFit.contain,
//                 errorBuilder: (_, __, ___) =>
//                     Icon(Icons.icecream, size: 120.r, color: cs.primary),
//               ),
//
//               // "Welcome"
//               SizedBox(height: 20.h),
//               Text(
//                 'wt0_title'.tr(), // "Welcome"
//                 style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
//               ),
//
//               // body text
//               SizedBox(height: 10.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 12.w),
//                 child: Text(
//                   'wt0_body'.tr(),
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14.sp, height: 1.45, color: cs.onSurfaceVariant),
//                 ),
//               ),
//
//               // CTA
//               SizedBox(height: 24.h),
//               SizedBox(
//                 width: double.infinity,
//                 height: 48.h,
//                 child: FilledButton(
//                   onPressed: () => _goSignIn(context),
//                   child: Text('get_started'.tr(), style: TextStyle(fontSize: 14.5.sp)),
//                 ),
//               ),
//               SizedBox(height: 16.h),
//             ],
//           ),
//         ),

//       ),
//     );
//   }
// }
