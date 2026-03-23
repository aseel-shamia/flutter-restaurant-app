import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../../shared/state/theme_notifier.dart';

/// شاشة Best Picks التي تفتح من زر See all
class FeaturedPartnersScreen extends StatelessWidget {
  const FeaturedPartnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final currentLang = context.locale.languageCode;
    final themeNotifier = context.watch<ThemeNotifier>();

    // بيانات Best Picks
    final items = <PartnerItem>[
      const PartnerItem(
        'assets/images/oo.png',
        "McDonald's",
        ['Burgers', 'Fast Food'],
        4.5,
      ),
      const PartnerItem(
        'assets/images/ooo.png',
        "The Halal Guys",
        ['Middle Eastern', 'Fast Food'],
        4.4,
      ),
      const PartnerItem(
        'assets/images/ppp.png',
        'Asian Delight',
        ['Chinese', 'Noodles'],
        4.3,
      ),
      const PartnerItem(
        'assets/images/pg.png',
        'Cafe Latte',
        ['Coffee', 'Snacks'],
        4.6,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // -----------------------------------------------------------------
            // شريط علوي: رجوع + عنوان + لغة + ثيم
            // -----------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    splashRadius: 22,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    'best_picks_title'.tr(), // ← أضفها في JSON
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),

                  const Spacer(),

                  // زر اللغة
                  PopupMenuButton<Locale>(
                    tooltip: 'language'.tr(),
                    onSelected: (locale) => context.setLocale(locale),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: const Locale('en'),
                        child: Row(
                          children: [
                            if (currentLang == 'en')
                              const Icon(Icons.check, size: 18),
                            if (currentLang == 'en')
                              const SizedBox(width: 6),
                            const Text('EN'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: const Locale('ar'),
                        child: Row(
                          children: [
                            if (currentLang == 'ar')
                              const Icon(Icons.check, size: 18),
                            if (currentLang == 'ar')
                              const SizedBox(width: 6),
                            const Text('AR'),
                          ],
                        ),
                      ),
                    ],
                    icon: const Icon(Icons.language),
                  ),

                  const SizedBox(width: 8),

                  // زر الثيم
                  IconButton(
                    tooltip: 'theme'.tr(),
                    icon: Icon(
                      themeNotifier.isDark
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                    ),
                    color: Colors.grey[400],
                    onPressed: () => themeNotifier.toggleTheme(),
                  ),
                ],
              ),
            ),

            // -----------------------------------------------------------------
            // Grid الكروت
            // -----------------------------------------------------------------
            Expanded(
              child: GridView.builder(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.70,
                ),
                itemCount: items.length,
                itemBuilder: (_, i) => PartnerCard(item: items[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== Model =====================
class PartnerItem {
  final String imagePath;
  final String name;
  final List<String> cuisines;
  final double rating;

  const PartnerItem(
      this.imagePath,
      this.name,
      this.cuisines,
      this.rating,
      );
}

// ===================== Card Widget =====================
class PartnerCard extends StatelessWidget {
  final PartnerItem item;
  const PartnerCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 0.9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(item.imagePath, fit: BoxFit.cover),

                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.15),
                          Colors.black.withOpacity(0.35),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Row(
                    children: const [
                      _InlineChip(icon: Icons.schedule, text: '25min'),
                      SizedBox(width: 6),
                      _InlineChip(icon: Icons.attach_money, text: 'Free'),
                    ],
                  ),
                ),

                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(.95),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star,
                            size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          item.cuisines.join('  •  '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ===================== Inline Chip =====================
class _InlineChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InlineChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.35),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          const SizedBox(width: 2),
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
