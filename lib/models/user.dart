class UserModel {
  final String name;
  final String username;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final String email;
  // final List<String> groupId;
  UserModel({
    required this.name,
    required this.username,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.email,
    // required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'username': username,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'email': email,
      // 'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      email: map['phoneNumber'] ?? '',
      // ignore: unrelated_type_equality_checks
      // groupId: (List<String>.from(map['groupId']) ?? []) as List<String>,
    );
  }
}