class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String contactNumber;
  final String role;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.contactNumber,
    this.role = "Undecided",
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      role: map['role'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'contactNumber': contactNumber,
      'role' : role,
    };
  }
}