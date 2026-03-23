// lib/app/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

// Splash & Walkthrough
import '../features/splash/presentation/splash_screen.dart';
import '../features/walkthrough/presentation/welcome_screen.dart';
import '../features/walkthrough/presentation/intro_walkthrough_screen.dart';

// Featured
import '../features/featured/presentation/featured_partners_screen.dart';
import '../features/featured/presentation/best_picks_all_screen.dart';
import '../features/featured/presentation/all_restaurants_all_screen.dart';

// Auth (Email/Password)
import '../features/auth/presentation/sign_in_screen.dart';
import '../features/auth/presentation/sign_up_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/reset_email_sent_screen.dart';

// Auth (Phone)
import '../features/auth/presentation/login_phone_screen.dart';
import '../features/auth/presentation/confirm_phone_screen.dart';
import '../features/auth/presentation/otp_verification_screen.dart';

// Home & other screens
import '../features/home/presentation/home_screen.dart';
import '../features/home/presentation/search_screen.dart';
import '../features/home/presentation/orders_screen.dart';

// Profile
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/edit_account_screen.dart';
import '../features/profile/presentation/delivery_addresses_screen.dart';
import '../features/profile/presentation/payment_methods_screen.dart';
import '../features/profile/presentation/notifications_screen.dart';
import '../features/profile/presentation/language_screen.dart';
import '../features/profile/presentation/privacy_security_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.welcome,
    routes: [
      // Root -> redirect
      GoRoute(
        path: AppRoutes.root,
        name: 'root',
        redirect: (_, __) => AppRoutes.welcome,
      ),

      // Splash
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.nSplash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Welcome
      GoRoute(
        path: AppRoutes.welcome,
        name: AppRoutes.nWelcome,
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Intro Walkthrough
      GoRoute(
        path: AppRoutes.intro,
        name: AppRoutes.nIntro,
        builder: (context, state) => const IntroWalkthroughScreen(),
      ),

      // Auth Email
      GoRoute(
        path: AppRoutes.signin,
        name: AppRoutes.nSignin,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: AppRoutes.nSignup,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgot,
        name: AppRoutes.nForgot,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.reset,
        name: AppRoutes.nReset,
        builder: (context, state) => const ResetEmailSentScreen(),
      ),

      // Auth Phone
      GoRoute(
        path: AppRoutes.loginPhone,
        name: AppRoutes.nLoginPhone,
        builder: (context, state) => const LoginPhoneScreen(),
      ),
      GoRoute(
        path: AppRoutes.confirmPhone,
        name: AppRoutes.nConfirmPhone,
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return ConfirmPhoneScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.otp,
        name: AppRoutes.nOtp,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final verificationId = extra['verificationId'] as String? ?? '';
          final phone = extra['phone'] as String? ?? '';

          return OtpVerificationScreen(
            verificationId: verificationId,
            phoneNumber: phone,
          );
        },
      ),

      // Home
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.nHome,
        builder: (context, state) => const HomeScreen(),
      ),

      // Featured Partners (See All)
      GoRoute(
        path: AppRoutes.featured,
        name: AppRoutes.nFeatured,
        builder: (context, state) => const FeaturedPartnersScreen(),
      ),

      // Search
      GoRoute(
        path: AppRoutes.search,
        name: AppRoutes.nSearch,
        builder: (context, state) => const SearchScreen(),
      ),

      // Orders
      GoRoute(
        path: AppRoutes.orders,
        name: AppRoutes.nOrders,
        builder: (context, state) => const OrdersScreen(),
      ),

      // Profile main screen
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.nProfile,
        builder: (context, state) => const ProfileScreen(),
      ),

      // --- Profile sub-screens ---
      GoRoute(
        path: AppRoutes.editAccount,
        name: AppRoutes.nEditAccount,
        builder: (context, state) => const EditAccountScreen(),
      ),
      GoRoute(
        path: AppRoutes.deliveryAddresses,
        name: AppRoutes.nDeliveryAddresses,
        builder: (context, state) => const DeliveryAddressesScreen(),
      ),
      GoRoute(
        path: AppRoutes.paymentMethods,
        name: AppRoutes.nPaymentMethods,
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: AppRoutes.nNotifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.language,
        name: AppRoutes.nLanguage,
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacySecurity,
        name: AppRoutes.nPrivacySecurity,
        builder: (context, state) => const PrivacySecurityScreen(),
      ),

      // Best Picks - SEE ALL
      GoRoute(
        path: AppRoutes.bestPicksAll,
        name: AppRoutes.nBestPicksAll,
        builder: (context, state) => const BestPicksAllScreen(),
      ),

      // All Restaurants - SEE ALL
      GoRoute(
        path: AppRoutes.allRestaurantsAll,
        name: AppRoutes.nAllRestaurantsAll,
        builder: (context, state) => const AllRestaurantsAllScreen(),
      ),
    ],
  );
}
