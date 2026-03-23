// lib/features/home/presentation/orders_screen.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/app_bottom_nav_bar.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    const accent = Color(0xFFF4A300);

    // بيانات افتراضية تشبه الفيغما
    final upcoming = <OrderItem>[
      OrderItem(
        restaurant: "McDonald's",
        itemsSummary: 'Cookie Sandwich, chocolate turtle cookies, and more',
        total: 27.50,
        statusText: 'orders_on_the_way'.tr(), // On the way
        statusColor: Colors.green,
        isUpcoming: true,
      ),
      OrderItem(
        restaurant: 'Linda Bakery',
        itemsSummary: 'Cheese cake, donuts and croissants',
        total: 18.90,
        statusText: 'orders_payment_pending'.tr(), // Payment pending
        statusColor: Colors.orange,
        isUpcoming: true,
      ),
    ];

    final past = <OrderItem>[
      OrderItem(
        restaurant: 'The Halal Guys',
        itemsSummary: 'Beef sandwich and fries',
        total: 22.10,
        statusText: 'orders_delivered'.tr(), // Delivered
        statusColor: Colors.grey,
        isUpcoming: false,
      ),
      OrderItem(
        restaurant: "Cafe Brichor's",
        itemsSummary: 'Latte, cookies and snacks',
        total: 14.20,
        statusText: 'orders_delivered'.tr(),
        statusColor: Colors.grey,
        isUpcoming: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('orders_title'.tr()), // Your Orders
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Upcoming orders =====
              Text(
                'orders_upcoming'.tr(), // Upcoming orders
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: cs.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < upcoming.length; i++) ...[
                      _OrderTile(
                        item: upcoming[i],
                        accent: accent,
                        isLast: i == upcoming.length - 1,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== Past orders =====
              Text(
                'orders_past'.tr(), // Past orders
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: cs.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < past.length; i++) ...[
                      _OrderTile(
                        item: past[i],
                        accent: accent,
                        isLast: i == past.length - 1,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // زر Orders مفعّل
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}

/// موديل بسيط للطلب
class OrderItem {
  final String restaurant;
  final String itemsSummary;
  final double total;
  final String statusText;
  final Color statusColor;
  final bool isUpcoming;

  OrderItem({
    required this.restaurant,
    required this.itemsSummary,
    required this.total,
    required this.statusText,
    required this.statusColor,
    required this.isUpcoming,
  });
}

/// كارت طلب واحد داخل القائمة
class _OrderTile extends StatelessWidget {
  final OrderItem item;
  final Color accent;
  final bool isLast;

  const _OrderTile({
    required this.item,
    required this.accent,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            item.restaurant,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                item.itemsSummary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    '\$${item.total.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: item.statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.statusText,
                      style: TextStyle(
                        fontSize: 11,
                        color: item.statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // أزرار أسفل كل طلب (حسب النوع)
        Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (item.isUpcoming)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cs.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // TODO: إلغاء الطلب
                  },
                  child: Text(
                    'orders_cancel'.tr(), // Cancel
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              else
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cs.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // TODO: إعادة الطلب
                  },
                  child: Text(
                    'orders_reorder'.tr(), // Reorder
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              const SizedBox(width: 8),
              if (item.isUpcoming)
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // TODO: متابعة الدفع (انتقل لصفحة الدفع)
                      },
                      child: Text(
                        'orders_proceed_payment'.tr(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                )
              else
                const Spacer(),
            ],
          ),
        ),

        if (!isLast)
          Divider(
            height: 8,
            thickness: 0.4,
            indent: 16,
            endIndent: 16,
            color: cs.outlineVariant,
          ),
      ],
    );
  }
}
