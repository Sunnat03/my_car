class Post {
  late String postKey;
  late String userId;
  late String name;
  late String description;
  List<String>? image;

  Post({
    required this.postKey,
    required this.userId,
    required this.name,
    required this.description,
    this.image});

  Post.fromJson(Map<String, dynamic> json) {
    postKey = json['postKey'];
    userId = json['userId'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() => {
    'postKey': postKey,
    'userId': userId,
    'description': description,
    'name': name,
    'image': image,
  };
}