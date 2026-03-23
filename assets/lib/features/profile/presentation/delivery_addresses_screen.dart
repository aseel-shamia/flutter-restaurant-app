// lib/features/profile/presentation/delivery_addresses_screen.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DeliveryAddressesScreen extends StatefulWidget {
  const DeliveryAddressesScreen({super.key});

  @override
  State<DeliveryAddressesScreen> createState() =>
      _DeliveryAddressesScreenState();
}

class _DeliveryAddressesScreenState extends State<DeliveryAddressesScreen> {
  final List<String> _addresses = [
    'Home – Gaza, Main street, Building 12',
    'Work – City center, Office 204',
  ];

  void _addAddress() {
    // demo بس – في الحقيقة هتفتحي فورم
    setState(() {
      _addresses.add('New address ${_addresses.length + 1}');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New address added (demo)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('profile_addresses'.tr()),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: _addresses.length,
        itemBuilder: (context, index) {
          final address = _addresses[index];
          return Card(
            color: cs.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                index == 0 ? Icons.home_outlined : Icons.work_outline,
              ),
              title: Text(address.split('–').first.trim()),
              subtitle: Text(address.split('–').last.trim()),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  setState(() => _addresses.removeAt(index));
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAddress,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Add new address'),
      ),
    );
  }
}
