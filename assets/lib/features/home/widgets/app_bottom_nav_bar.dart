// lib/features/home/widgets/app_bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../app/app_routes.dart';

class AppBottomNavBar extends StatelessWidget {
  /// 0 = Home, 1 = Search, 2 = Orders, 3 = Profile
  final int currentIndex;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_filled,
            labelKey: 'nav_home',          // مفتاح الترجمة
            active: currentIndex == 0,
            onTap: () => context.goNamed(AppRoutes.nHome),
          ),
          _NavItem(
            icon: Icons.search,
            labelKey: 'nav_search',
            active: currentIndex == 1,
            onTap: () => context.goNamed(AppRoutes.nSearch),
          ),
          _NavItem(
            icon: Icons.shopping_bag,
            labelKey: 'nav_orders',
            active: currentIndex == 2,
            onTap: () => context.goNamed(AppRoutes.nOrders),
          ),
          _NavItem(
            icon: Icons.person,
            labelKey: 'nav_profile',
            active: currentIndex == 3,
            onTap: () => context.goNamed(AppRoutes.nProfile),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String labelKey;   // مفتاح الترجمة
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    super.key,
    required this.icon,
    required this.labelKey,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active ? theme.colorScheme.primary : Colors.grey[400],
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            labelKey.tr(), // ترجمة العنوان حسب اللغة
            style: TextStyle(
              fontSize: 12,
              color: active ? theme.colorScheme.primary : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
