import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/firebase_db_service.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseDbService();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: const Color(0xFF6A5AE0),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openUserDialog(context, db),
        backgroundColor: const Color(0xFF6A5AE0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder(
        stream: db.users().orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          final docs = snapshot.data?.docs ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (docs.isEmpty) {
            return const Center(child: Text('No users yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();
              final username = data['username'] ?? 'User';
              final email = data['email'] ?? '';
              final role = data['role'] ?? 'user';
              final diamonds = data['diamonds'] ?? 0;
              return _UserTile(
                username: username,
                email: email,
                role: role,
                diamonds: diamonds.toString(),
                onEdit: () => _openUserDialog(
                  context,
                  db,
                  docId: doc.id,
                  initial: data,
                ),
                onDelete: () => _confirmDelete(
                  context,
                  () => db.users().doc(doc.id).delete(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.username,
    required this.email,
    required this.role,
    required this.diamonds,
    required this.onEdit,
    required this.onDelete,
  });

  final String username;
  final String email;
  final String role;
  final String diamonds;
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
            child: const Icon(Icons.person, color: Color(0xFF6A5AE0)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
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
                  'Role: $role • Diamonds: $diamonds',
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

Future<void> _openUserDialog(
  BuildContext context,
  FirebaseDbService db, {
  String? docId,
  Map<String, dynamic>? initial,
}) async {
  final usernameCtrl =
      TextEditingController(text: initial?['username']?.toString() ?? '');
  final emailCtrl =
      TextEditingController(text: initial?['email']?.toString() ?? '');
  final diamondsCtrl = TextEditingController(
    text: (initial?['diamonds'] ?? 0).toString(),
  );
  String role = initial?['role']?.toString() ?? 'user';
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(docId == null ? 'Add User' : 'Edit User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: usernameCtrl,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: emailCtrl,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: diamondsCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Diamonds'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: role,
            items: const [
              DropdownMenuItem(value: 'user', child: Text('user')),
              DropdownMenuItem(value: 'admin', child: Text('admin')),
              DropdownMenuItem(value: 'guest', child: Text('guest')),
            ],
            onChanged: (value) => role = value ?? 'user',
            decoration: const InputDecoration(labelText: 'Role'),
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
              'username': usernameCtrl.text.trim(),
              'email': emailCtrl.text.trim(),
              'role': role,
              'diamonds': int.tryParse(diamondsCtrl.text.trim()) ?? 0,
              'updatedAt': FieldValue.serverTimestamp(),
            };
            if (docId == null) {
              data['createdAt'] = FieldValue.serverTimestamp();
              await db.users().add(data);
            } else {
              await db.users().doc(docId).set(data, SetOptions(merge: true));
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
      title: const Text('Delete user?'),
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
