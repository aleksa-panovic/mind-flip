import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/firebase_db_service.dart';

class AdminShopItemsScreen extends StatefulWidget {
  const AdminShopItemsScreen({super.key});

  @override
  State<AdminShopItemsScreen> createState() => _AdminShopItemsScreenState();
}

class _AdminShopItemsScreenState extends State<AdminShopItemsScreen> {
  bool _seeded = false;

  @override
  Widget build(BuildContext context) {
    final db = FirebaseDbService();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Shop Items'),
        backgroundColor: const Color(0xFF6A5AE0),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openItemDialog(context, db),
        backgroundColor: const Color(0xFF6A5AE0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder(
        stream: db.shopItems().orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          final docs = snapshot.data?.docs ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (docs.isEmpty && !_seeded) {
            _seeded = true;
            Future.microtask(() => _seedDefaults(db));
          }
          if (docs.isEmpty) {
            return const Center(child: Text('No shop items yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();
              final name = data['name'] ?? 'Item';
              final key = data['itemKey'] ?? '';
              final type = data['itemType'] ?? '';
              final price = data['price']?.toString() ?? '0';
              final currency = data['currency'] ?? '';
              return _ItemTile(
                name: name,
                subtitle: '$type • $key',
                price: '$price $currency',
                onEdit: () => _openItemDialog(
                  context,
                  db,
                  docId: doc.id,
                  initial: data,
                ),
                onDelete: () => _confirmDelete(
                  context,
                  () => db.shopItems().doc(doc.id).delete(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _seedDefaults(FirebaseDbService db) async {
    final batch = FirebaseFirestore.instance.batch();
    final now = FieldValue.serverTimestamp();
    final items = [
      {
        'id': 'front_animal',
        'name': 'Animal',
        'itemKey': 'animal',
        'itemType': 'front_skin',
        'price': 3.99,
        'currency': 'usd',
      },
      {
        'id': 'front_space',
        'name': 'Space',
        'itemKey': 'space',
        'itemType': 'front_skin',
        'price': 5.99,
        'currency': 'usd',
      },
      {
        'id': 'front_sport',
        'name': 'Sport',
        'itemKey': 'sport',
        'itemType': 'front_skin',
        'price': 4.99,
        'currency': 'usd',
      },
      {
        'id': 'back_galaxy',
        'name': 'Galaxy',
        'itemKey': 'galaxy',
        'itemType': 'back_skin',
        'price': 1000,
        'currency': 'diamonds',
      },
      {
        'id': 'back_nature',
        'name': 'Nature',
        'itemKey': 'nature',
        'itemType': 'back_skin',
        'price': 2000,
        'currency': 'diamonds',
      },
      {
        'id': 'back_lava',
        'name': 'Lava',
        'itemKey': 'lava',
        'itemType': 'back_skin',
        'price': 5000,
        'currency': 'diamonds',
      },
    ];
    for (final item in items) {
      final doc = db.shopItems().doc(item['id'] as String);
      batch.set(
        doc,
        {
          ...item,
          'createdAt': now,
          'updatedAt': now,
        },
        SetOptions(merge: true),
      );
    }
    await batch.commit();
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.name,
    required this.subtitle,
    required this.price,
    required this.onEdit,
    required this.onDelete,
  });

  final String name;
  final String subtitle;
  final String price;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF2EAFE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shopping_bag, color: Color(0xFF6A5AE0)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  price,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, color: Color(0xFF6A5AE0)),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Color(0xFFF25555)),
          ),
        ],
      ),
    );
  }
}

Future<void> _openItemDialog(
  BuildContext context,
  FirebaseDbService db, {
  String? docId,
  Map<String, dynamic>? initial,
}) async {
  final nameCtrl =
      TextEditingController(text: initial?['name']?.toString() ?? '');
  final keyCtrl =
      TextEditingController(text: initial?['itemKey']?.toString() ?? '');
  final priceCtrl =
      TextEditingController(text: (initial?['price'] ?? 0).toString());
  String type = initial?['itemType']?.toString() ?? 'front_skin';
  String currency = initial?['currency']?.toString() ?? 'usd';

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(docId == null ? 'Add Item' : 'Edit Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: keyCtrl,
            decoration: const InputDecoration(labelText: 'Item Key'),
          ),
          TextField(
            controller: priceCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Price'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: type,
            items: const [
              DropdownMenuItem(value: 'front_skin', child: Text('front_skin')),
              DropdownMenuItem(value: 'back_skin', child: Text('back_skin')),
            ],
            onChanged: (value) => type = value ?? 'front_skin',
            decoration: const InputDecoration(labelText: 'Item Type'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: currency,
            items: const [
              DropdownMenuItem(value: 'usd', child: Text('usd')),
              DropdownMenuItem(value: 'diamonds', child: Text('diamonds')),
            ],
            onChanged: (value) => currency = value ?? 'usd',
            decoration: const InputDecoration(labelText: 'Currency'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final data = {
              'name': nameCtrl.text.trim(),
              'itemKey': keyCtrl.text.trim(),
              'itemType': type,
              'price': double.tryParse(priceCtrl.text.trim()) ?? 0,
              'currency': currency,
              'updatedAt': FieldValue.serverTimestamp(),
            };
            if (docId == null) {
              data['createdAt'] = FieldValue.serverTimestamp();
              await db.shopItems().add(data);
            } else {
              await db.shopItems().doc(docId).set(data, SetOptions(merge: true));
            }
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

Future<void> _confirmDelete(
  BuildContext context,
  Future<void> Function() onDelete,
) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete item?'),
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (ok == true) {
    await onDelete();
  }
}
