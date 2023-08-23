class ChatUser {
  late String id;
  late String image;
  late String about;
  late String name;
  late String createdAt;
  late bool isOnline;
  late String lastActive;
  late String email;
  late String pushToken;
  ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.about,
    required this.isOnline,
    required this.createdAt,
    required this.lastActive,
    required this.pushToken,
  });

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    isOnline = json['is_online'] ?? '';
    createdAt = json['created_at'] ?? '';
    lastActive = json['last_active'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'image': image,
        'about': about,
        'is_online': isOnline,
        'created_at': createdAt,
        'last_active': lastActive,
        'push_token': pushToken,
      };
}
