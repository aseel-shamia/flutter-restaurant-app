import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../shared/state/theme_notifier.dart';
import '../../../app/app_routes.dart';
import '../widgets/app_bottom_nav_bar.dart';

/// شاشة الهوم الرئيسية
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  Future<void> _initFCM() async {
    await _requestNotificationPermission();
    await _getDeviceToken();
    _listenToForegroundMessages();
  }

  Future<void> _requestNotificationPermission() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');
  }

  Future<void> _getDeviceToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('📱 FCM Token: $token');

    setState(() {
      _fcmToken = token;
    });
  }

  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'FCM Message';
      final body = message.notification?.body ?? '';

      debugPrint('📩 FCM Foreground: $title - $body');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title\n$body'),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // جسم الصفحة
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _TopActionsBar(), // شريط اللغة + زر الثيم
              _HomeHeader(), // نص DELIVERY TO + العنوان
              SizedBox(height: 12),
              _HeaderBanner(), // صورة البانر الكبيرة
              SizedBox(height: 16),
              _FeaturedPartnersSection(), // سكشن Featured Partners
              SizedBox(height: 24),
              _BestPicksSection(), // سكشن Best Picks
              SizedBox(height: 24),
              _AllRestaurantsSection(), // سكشن All Restaurants
              SizedBox(height: 90), // مساحة أسفل حتى لا يغطيه الـ bottom bar
            ],
          ),
        ),
      ),

      // شريط التنقل السفلي الجديد
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}

/// الشريط العلوي (أيقونة اللغة + زر تغيير وضع الثيم)
class _TopActionsBar extends StatelessWidget {
  const _TopActionsBar();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final currentLang = context.locale.languageCode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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

          const SizedBox(width: 8),

          // 🌙/☀️ زر تغيير وضع الإضاءة (داكن / مضيء)
          IconButton(
            icon: Icon(
              themeNotifier.isDark
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            color: Colors.grey[400],
            tooltip: 'theme'.tr(),
            onPressed: () => themeNotifier.toggleTheme(),
          ),
        ],
      ),
    );
  }
}

/// الهيدر: DELIVERY TO + العنوان + Filter
class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'home_delivery_to'.tr(), // DELIVERY TO
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.5,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  // العنوان ممكن تخليه ثابت أو تربطه بمفتاح ترجمة لو حاب
                  Text(
                    'HayStreet, Perth',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                ],
              ),
            ],
          ),
          Text(
            'home_filter'.tr(), // Filter
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// صورة البانر الكبيرة تحت الهيدر
class _HeaderBanner extends StatelessWidget {
  const _HeaderBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 190,
          child: Image.asset(
            'assets/images/Header (1).png', // صورة البانر الرئيسية
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

/// سكشن Featured Partners (أول سلايدر أفقي)
class _FeaturedPartnersSection extends StatelessWidget {
  const _FeaturedPartnersSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان + See all
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'home_featured_partners'.tr(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // التنقل لصفحة Featured Partners
                  context.push(AppRoutes.featured);
                },
                child: Text(
                  'see_all'.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // سلايدر الكروت
          SizedBox(
            height: 240,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _RestaurantCard(
                  imagePath: 'assets/images/coffee.png',
                  title: 'Krispy Creme',
                  address: 'St Georgece Terrace, Perth',
                ),
                SizedBox(width: 12),
                _RestaurantCard(
                  imagePath: 'assets/images/noodles.png',
                  title: 'Mario Italiano',
                  address: 'Hay street, Perth City',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// كارت مطعم صغير (يُستخدم في Featured + Best Picks)
class _RestaurantCard extends StatelessWidget {
  final String imagePath; // مسار الصورة من assets/images
  final String title; // اسم المطعم
  final String address; // عنوان المطعم

  const _RestaurantCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المطعم داخل الكارت
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 8),

          // اسم المطعم
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          // عنوان المطعم
          Text(
            address,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 6),

          // السطر الأخير: تقييم + وقت التوصيل + Free delivery
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.star, size: 14, color: Colors.orange),
                      SizedBox(width: 3),
                      Text('4.5'),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text('25min', style: theme.textTheme.bodySmall),
                const SizedBox(width: 8),
                Text('Free delivery', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// سكشن Best Picks Restaurants by team (السلايدر الثاني)
class _BestPicksSection extends StatelessWidget {
  const _BestPicksSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان + See all
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'home_best_picks'.tr(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // ← يفتح صفحة BestPicksAllScreen
                  context.push(AppRoutes.bestPicksAll);
                },
                child: Text(
                  'see_all'.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // السلايدر الأفقي للكروت
          SizedBox(
            height: 240,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _RestaurantCard(
                  imagePath: 'assets/images/mcdonalds.png',
                  title: "McDonald's",
                  address: 'Hay street, Perth City',
                ),
                SizedBox(width: 12),
                _RestaurantCard(
                  imagePath: 'assets/images/ppp.png',
                  title: 'The Halal Guys',
                  address: 'Hay street, Perth City',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// سكشن All Restaurants (الكروت الكبيرة بالطول مثل الصورة)
class _AllRestaurantsSection extends StatelessWidget {
  const _AllRestaurantsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان + See all
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'home_all_restaurants'.tr(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // ← يفتح صفحة AllRestaurantsAllScreen
                  context.push(AppRoutes.allRestaurantsAll);
                },
                child: Text(
                  'see_all'.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // الكارت الأول
          const _AllRestaurantCard(
            imagePath: 'assets/images/1111111.png',
            name: "McDonald's",
            foodTypes: [
              'Chinese',
              'American',
              'Deshi food',
            ],
          ),

          const SizedBox(height: 16),

          // الكارت الثاني
          const _AllRestaurantCard(
            imagePath: 'assets/images/3333.png',
            name: 'Cafe Brichor’s',
            foodTypes: [
              'Chinese',
              'American',
              'Deshi food',
            ],
          ),
        ],
      ),
    );
  }
}

/// كارت مطعم لسكشن All Restaurants (بدون $$ - مثل الصورة)
class _AllRestaurantCard extends StatelessWidget {
  final String imagePath; // مسار صورة المطعم
  final String name; // اسم المطعم
  final List<String> foodTypes; // أنواع الأكل (Chinese, American, ...)

  const _AllRestaurantCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.foodTypes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// صورة المطعم
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              imagePath,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// اسم المطعم
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                /// السطر الثاني: أنواع الأكل فقط (بدون $$)
                Wrap(
                  spacing: 4,
                  children: [
                    for (int i = 0; i < foodTypes.length; i++) ...[
                      Text(
                        foodTypes[i],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      if (i != foodTypes.length - 1)
                        Text(
                          '·',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ],
                ),

                const SizedBox(height: 6),

                /// السطر الأخير: ⭐ 4.3  200+ Ratings  25 min  Free
                Row(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.star, size: 16, color: Colors.orange),
                        SizedBox(width: 4),
                        Text('4.3'),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '200+ Ratings',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '25 min',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Free',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
