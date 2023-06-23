class Status {
  final String uid;
  final String username;
  final List<String> photoUrl;
  final DateTime createdAt;
  final String profilePic;
  final bool isSeen;
  final String statusId;
  final List<String> whoCanSee;
  Status({
    required this.uid,
    required this.username,
    required this.photoUrl,
    required this.createdAt,
    required this.isSeen,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSee,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCanSee,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      isSeen: map['isSeen'] ?? false,
      photoUrl: List<String>.from(map['photoUrl']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      profilePic: map['profilePic'] ?? '',
      statusId: map['statusId'] ?? '',
      whoCanSee: List<String>.from(map['whoCanSee']),
    );
 
  }
}