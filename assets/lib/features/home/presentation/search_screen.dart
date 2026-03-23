// lib/features/home/presentation/search_screen.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../../shared/state/theme_notifier.dart';
import '../widgets/app_bottom_nav_bar.dart';

/// شاشة Search مع فلترة النتائج + Recent Searches
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;

  /// كل العناصر الأصلية
  late final List<PartnerItem> _items;

  /// العناصر بعد الفلترة
  late List<PartnerItem> _filteredItems;

  /// عمليات البحث الأخيرة (قائمة بسيطة الآن)
  final List<String> recentSearches = <String>[
    "McDonald's",
    'Cafe MayField’s',
    'Latte House',
    'Chinese Food',
  ];

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController()..addListener(_onQueryChanged);

    _items = [
      const PartnerItem(
        'assets/images/hh.png',
        'Tacos Nanchas',
        ['Chinese', 'American'],
        4.5,
        '\$\$',
      ),
      const PartnerItem(
        'assets/images/pg.png',
        "McDonald's",
        ['Chinese', 'American'],
        4.5,
        '\$\$',
      ),
      const PartnerItem(
        'assets/images/oo.png',
        'KFC Foods',
        ['Chinese', 'American'],
        4.5,
        '\$\$',
      ),
      const PartnerItem(
        'assets/images/ooo.png',
        'Cafe MayField’s',
        ['Chinese', 'American'],
        4.5,
        '\$\$',
      ),
      const PartnerItem(
        'assets/images/oo.png',
        'Burger Town',
        ['Chinese', 'American'],
        4.5,
        '\$\$',
      ),
      const PartnerItem(
        'assets/images/oopp.png',
        'Latte House',
        ['Chinese', 'American'],
        4.5,
        '\$\$',
      ),
    ];

    _filteredItems = List.of(_items);
  }

  @override
  void dispose() {
    _controller.removeListener(_onQueryChanged);
    _controller.dispose();
    super.dispose();
  }

  /// كلما المستخدم كتب في خانة البحث
  void _onQueryChanged() {
    final query = _controller.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.of(_items);
      } else {
        _filteredItems = _items.where((item) {
          final nameMatch = item.name.toLowerCase().contains(query);
          final cuisineMatch = item.cuisines.any(
                (c) => c.toLowerCase().contains(query),
          );
          return nameMatch || cuisineMatch;
        }).toList();
      }
    });
  }

  void _clearRecent() {
    setState(recentSearches.clear);
  }

  void _useRecent(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final currentLang = context.locale.languageCode;
    final themeNotifier = context.watch<ThemeNotifier>();

    final showResults = _controller.text.trim().isNotEmpty;

    return Scaffold(
      // تفعيل تبويب Search في الـ BottomNav
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== الشريط العلوي: رجوع + عنوان + لغة + ثيم =====
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    splashRadius: 22,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'search_title'.tr(), // Search
                    style: TextStyle(
                      fontSize: 20,
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

            const SizedBox(height: 4),

            // ===== حقل البحث =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'search_hint'.tr(), // Search on foodly
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => _controller.clear(),
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: cs.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: cs.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: cs.primary, width: 1.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===== العنوان حسب الحالة =====
            if (!showResults) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Recent Searches',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed:
                      recentSearches.isEmpty ? null : _clearRecent,
                      child: const Text('CLEAR ALL'),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'top_restaurants'.tr(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 8),

            // ===== المحتوى: إما Grid (نتائج) أو قائمة Recent =====
            Expanded(
              child: showResults
                  ? GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemCount: _filteredItems.length,
                itemBuilder: (_, i) =>
                    PartnerCard(item: _filteredItems[i]),
              )
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: recentSearches.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 12),
                itemBuilder: (_, i) => Row(
                  children: [
                    const Icon(Icons.history, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        recentSearches[i],
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.north_west, size: 18),
                      onPressed: () => _useRecent(recentSearches[i]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ===================== الموديل + الكارت كما كانت ===================== */

class PartnerItem {
  final String imagePath;
  final String name;
  final List<String> cuisines;
  final double rating;
  final String price; // $$

  const PartnerItem(
      this.imagePath,
      this.name,
      this.cuisines,
      this.rating,
      this.price,
      );
}

class PartnerCard extends StatelessWidget {
  final PartnerItem item;
  const PartnerCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1.15,
            child: Image.asset(
              item.imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${item.price}  ·  ${item.cuisines.join(' · ')}',
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
