// lib/app/app_routes.dart

class AppRoutes {
  /* ───────────────────────────
   * ROOT & WALKTHROUGH
   * ─────────────────────────── */
  static const root    = '/';
  static const splash  = '/splash';
  static const welcome = '/welcome';
  static const intro   = '/intro';

  static const nSplash  = 'splash';
  static const nWelcome = 'welcome';
  static const nIntro   = 'intro';

  /* ───────────────────────────
   * AUTH (Email)
   * ─────────────────────────── */
  static const signin = '/signin';
  static const signup = '/signup';
  static const forgot = '/forgot';
  static const reset  = '/reset';

  static const nSignin = 'signin';
  static const nSignup = 'signup';
  static const nForgot = 'forgot';
  static const nReset  = 'reset';

  /* ───────────────────────────
   * AUTH (Phone)
   * ─────────────────────────── */
  static const loginPhone   = '/login-phone';
  static const confirmPhone = '/confirm-phone';
  static const otp          = '/otp';

  static const nLoginPhone   = 'login_phone';
  static const nConfirmPhone = 'confirm_phone';
  static const nOtp          = 'otp';

  /* ───────────────────────────
   * HOME & MAIN SCREENS
   * ─────────────────────────── */
  static const home = '/home';
  static const nHome = 'home';

  static const typeLocation = '/type-location';
  static const nTypeLocation = 'type_location';

  static const singleFood = '/single-food';
  static const nSingleFood = 'single_food';

  /* ───────────────────────────
   * FEATURED (See all)
   * ─────────────────────────── */
  static const featured = '/featured';
  static const nFeatured = 'featured';

  // Best Picks (see all)
  static const bestPicksAll = '/best-picks-all';
  static const nBestPicksAll = 'best_picks_all';

  // All Restaurants (see all)
  static const allRestaurantsAll = '/all-restaurants-all';
  static const nAllRestaurantsAll = 'all_restaurants_all';

  /* ───────────────────────────
   * INDIVIDUAL SECTIONS
   * ─────────────────────────── */

  // Best Picks Home Section (NOT see all)
  static const bestPicks = '/best-picks';
  static const nBestPicks = 'bestPicks';

  // All Restaurants Home Section (NOT see all)
  static const allRestaurants = '/all-restaurants';
  static const nAllRestaurants = 'allRestaurants';

  /* ───────────────────────────
   * SEARCH – ORDERS – PROFILE
   * ─────────────────────────── */
  static const search   = '/search';
  static const nSearch  = 'search';

  static const orders   = '/orders';
  static const nOrders  = 'orders';

  static const profile  = '/profile';
  static const nProfile = 'profile';
  // -------- Profile sub-screens (الجديدة) --------
  static const editAccount = '/edit-account';
  static const nEditAccount = 'edit_account';

  static const deliveryAddresses = '/delivery-addresses';
  static const nDeliveryAddresses = 'delivery_addresses';

  static const paymentMethods = '/payment-methods';
  static const nPaymentMethods = 'payment_methods';

  static const notifications = '/notifications';
  static const nNotifications = 'notifications';

  static const language = '/language';
  static const nLanguage = 'language';

  static const privacySecurity = '/privacy-security';
  static const nPrivacySecurity = 'privacy_security';
}
