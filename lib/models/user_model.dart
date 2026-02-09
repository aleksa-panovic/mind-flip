class UserModel {
  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.role = UserRole.user,
  });

  final String id;
  final String username;
  final String email;
  final UserRole role;
}

enum UserRole { guest, user, admin }
