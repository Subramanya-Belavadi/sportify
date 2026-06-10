class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  static const List<UserModel> hardcodedUsers = [
    UserModel(id: 'user_1', name: 'Alice', email: 'alice@sportify.com', password: 'alice123'),
    UserModel(id: 'user_2', name: 'Bob', email: 'bob@sportify.com', password: 'bob123'),
    UserModel(id: 'user_3', name: 'Charlie', email: 'charlie@sportify.com', password: 'charlie123'),
  ];

  static UserModel? authenticate(String email, String password) {
    try {
      return hardcodedUsers.firstWhere(
        (u) => u.email == email.trim().toLowerCase() && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }
}
