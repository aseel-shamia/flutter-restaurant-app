import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // 🔔 FCM
import 'firebase_options.dart';
import 'app/app.dart';

/// 🔔 هذا الهاندلر يشتغل لما توصلك رسالة و التطبيق بالخلفية / مسكر
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // لازم نهيّء Firebase هنا لأن الهاندلر ممكن يشتغل قبل main()
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('🔔 Background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥  تهيئة EasyLocalization
  await EasyLocalization.ensureInitialized();

  // 🔥  تهيئة Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔔 ربط الهاندلر بالرسائل الخلفية
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 🔥  تشغيل التطبيق
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: const TamangApp(),
    ),
  );
}
