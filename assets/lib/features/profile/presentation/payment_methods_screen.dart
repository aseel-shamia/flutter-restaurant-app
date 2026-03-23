// lib/features/profile/presentation/payment_methods_screen.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selectedMethod = 'visa';

  void _addNewCard() {
    // demo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add new card (demo)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('profile_payment_methods'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Card(
            color: cs.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'visa',
                  groupValue: _selectedMethod,
                  onChanged: (v) => setState(() => _selectedMethod = v!),
                  title: const Text('Visa •••• 1234'),
                  subtitle: const Text('Expires 08/26'),
                  secondary: const Icon(Icons.credit_card),
                ),
                const Divider(height: 0),
                RadioListTile<String>(
                  value: 'master',
                  groupValue: _selectedMethod,
                  onChanged: (v) => setState(() => _selectedMethod = v!),
                  title: const Text('Mastercard •••• 5678'),
                  subtitle: const Text('Expires 03/27'),
                  secondary: const Icon(Icons.credit_card),
                ),
                const Divider(height: 0),
                RadioListTile<String>(
                  value: 'cash',
                  groupValue: _selectedMethod,
                  onChanged: (v) => setState(() => _selectedMethod = v!),
                  title: const Text('Cash'),
                  subtitle: const Text('Pay with cash on delivery'),
                  secondary: const Icon(Icons.account_balance_wallet_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addNewCard,
              icon: const Icon(Icons.add),
              label: const Text('Add new card'),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selected method: $_selectedMethod',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
