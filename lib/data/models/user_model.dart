class UserModel {
  final String id;
  final String name;

  const UserModel({required this.id, required this.name});

  // Hardcoded users — no auth needed per spec
  static const List<UserModel> hardcodedUsers = [
    UserModel(id: 'user_1', name: 'Alice'),
    UserModel(id: 'user_2', name: 'Bob'),
    UserModel(id: 'user_3', name: 'Charlie'),
  ];
}
