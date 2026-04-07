class UserModel {
  int? id;
  String email;
  String password;
  String role;

  UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}