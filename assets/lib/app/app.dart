// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'router.dart';
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';
import '../shared/state/theme_notifier.dart';

class TamangApp extends StatelessWidget {
  const TamangApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.router;

    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (_, theme, __) {
          return ScreenUtilInit(
            designSize: const Size(375, 812), // <— match Figma
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, __) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Tamang FoodService',
                routerConfig: router,
                theme: LightTheme.build(GoogleFonts.interTextTheme()),
                darkTheme: DarkTheme.build(GoogleFonts.interTextTheme()),
                themeMode: theme.mode,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
              );
            },

          );
        },
      ),
    );
  }
}
