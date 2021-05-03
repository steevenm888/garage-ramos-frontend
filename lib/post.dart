class Post {
  final String isLightOn;

  Post({this.isLightOn});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      isLightOn: json['isLightOn'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["isLightOn"] = isLightOn;
    return map;
  }
}