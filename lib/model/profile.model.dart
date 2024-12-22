
class Profile {
  int? userId;
  String userName;
  String fullName;
  String password;

  Profile({
    this.userId,
    required this.userName,
    required this.fullName,
    required this.password,
  });

  // Konversi objek ke Map (untuk SQLite)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'fullName': fullName,
      'password': password,
    };
  }
}
